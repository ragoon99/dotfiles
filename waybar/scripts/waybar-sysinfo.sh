#!/usr/bin/env bash
# waybar-sysinfo.sh — custom Waybar module
# Outputs JSON with: per-core CPU usage, RAM usage, CPU temperature, WiFi speeds
# Usage in waybar config: "exec": "/path/to/waybar-sysinfo.sh"
#                         "interval": 2
# Dependencies: bash, awk, coreutils, lm_sensors (for temp), jq (for JSON safety)

# ── helpers ─────────────────────────────────────────────────────────────────

# Read /proc/stat twice to compute real delta-based CPU usage.
# Returns space-separated per-core percentages (core0 core1 … coreN).
get_cpu_usage() {
	local delay=0.5

	# First sample
	mapfile -t lines1 < <(grep '^cpu[0-9]' /proc/stat)
	sleep "$delay"
	# Second sample
	mapfile -t lines2 < <(grep '^cpu[0-9]' /proc/stat)

	local result=()
	for i in "${!lines1[@]}"; do
		read -r _ u1 n1 s1 id1 io1 irq1 sirq1 _ <<<"${lines1[$i]}"
		read -r _ u2 n2 s2 id2 io2 irq2 sirq2 _ <<<"${lines2[$i]}"

		local idle1=$((id1 + io1))
		local idle2=$((id2 + io2))
		local total1=$((u1 + n1 + s1 + id1 + io1 + irq1 + sirq1))
		local total2=$((u2 + n2 + s2 + id2 + io2 + irq2 + sirq2))

		local dtotal=$((total2 - total1))
		local didle=$((idle2 - idle1))

		if ((dtotal == 0)); then
			result+=("0")
		else
			local pct=$(((dtotal - didle) * 100 / dtotal))
			result+=("$pct")
		fi
	done

	echo "${result[@]}"
}

# Returns used/total RAM in GiB as "used total"
get_ram() {
	awk '/^MemTotal/{total=$2} /^MemAvailable/{avail=$2}
         END {
             used  = (total - avail) / 1024 / 1024
             total = total / 1024 / 1024
             printf "%.1f %.1f", used, total
         }' /proc/meminfo
}

# Returns CPU temperature in °C (integer).
# Tries lm_sensors → /sys/class/thermal → fallback "N/A"
get_temp() {
	if command -v sensors &>/dev/null; then
		local t
		t=$(sensors 2>/dev/null |
			awk '/^(Tctl|Tdie|Core 0|Package id 0|CPU Temperature|temp1|k10temp)/ {
                       match($0, /[+-]([0-9]+(\.[0-9]*)?)°C/, arr)
                       if (arr[1] != "") { print int(arr[1]); exit }
                   }')
		[[ -n "$t" ]] && {
			echo "$t"
			return
		}
	fi

	for zone in /sys/class/thermal/thermal_zone*/temp; do
		[[ -f "$zone" ]] || continue
		local raw
		raw=$(cat "$zone" 2>/dev/null)
		local celsius=$((raw / 1000))
		if ((celsius > 0 && celsius < 120)); then
			echo "$celsius"
			return
		fi
	done

	echo "N/A"
}

# Returns WiFi speeds in KiB/s
get_wifi_speeds() {
	local iface="${WIFI_IFACE:-wlan0}"
	local rx_path="/sys/class/net/${iface}/statistics/rx_bytes"
	local tx_path="/sys/class/net/${iface}/statistics/tx_bytes"

	if [[ ! -f "$rx_path" ]]; then
		echo "0 0"
		return
	fi

	local rx1 tx1 rx2 tx2
	rx1=$(cat "$rx_path")
	tx1=$(cat "$tx_path")
	sleep 1
	rx2=$(cat "$rx_path")
	tx2=$(cat "$tx_path")

	echo "$(((rx2 - rx1) / 1024)) $(((tx2 - tx1) / 1024))"
}

# Pick a colour based on a percentage value (0-100)
pct_color() {
	local pct=$1
	if ((pct >= 90)); then
		echo "#ff5555"
	elif ((pct >= 70)); then
		echo "#ffb86c"
	elif ((pct >= 40)); then
		echo "#f1fa8c"
	else
		echo "#447a27"
	fi
}

# Pick a colour based on temperature
temp_color() {
	local t=$1
	[[ "$t" == "N/A" ]] && {
		echo "#bd93f9"
		return
	}
	if ((t >= 90)); then
		echo "#ff5555"
	elif ((t >= 75)); then
		echo "#ffb86c"
	elif ((t >= 60)); then
		echo "#f1fa8c"
	else
		echo "#447a27"
	fi
}

# ── Gather data ──────────────────────────────────────────────────────────────

# Run cpu sampling and wifi sampling concurrently to cut wall time.
# cpu_usage_file and wifi_file are temp files for subprocess output.
cpu_tmp=$(mktemp)
wifi_tmp=$(mktemp)
trap 'rm -f "$cpu_tmp" "$wifi_tmp"' EXIT

get_cpu_usage >"$cpu_tmp" &
get_wifi_speeds >"$wifi_tmp" &
wait

read -ra core_pcts <"$cpu_tmp"
read -r wifi_dl wifi_ul <"$wifi_tmp"

read -r ram_used ram_total <<<"$(get_ram)"
temp=$(get_temp)

# ── Build display strings ────────────────────────────────────────────────────

core_lines=""
core_bar_text=""
num_cores=${#core_pcts[@]}

bar_chars=("▁" "▂" "▃" "▄" "▅" "▆" "▇" "█")

for i in "${!core_pcts[@]}"; do
	p=${core_pcts[$i]}
	col=$(pct_color "$p")

	idx=$((p * 7 / 100))
	# idx can only reach 7 at p=100; clamp is a no-op in practice but kept for safety
	((idx > 7)) && idx=7
	bar="${bar_chars[$idx]}"

	core_bar_text+="<span foreground='${col}'>${bar}</span>"

	filled=$((p / 10))
	empty=$((10 - filled))

	# FIX #4: guard against seq 1 0 producing output on some systems
	bar_filled=""
	bar_empty=""
	((filled > 0)) && bar_filled=$(printf '█%.0s' $(seq 1 "$filled"))
	((empty > 0)) && bar_empty=$(printf '░%.0s' $(seq 1 "$empty"))

	core_lines+="C${i}  <span foreground='${col}'>${bar_filled}${bar_empty}</span>  ${p}%\n"
done

# FIX #3: use awk for float-safe RAM percentage instead of bash integer arithmetic
ram_pct=$(awk "BEGIN {printf \"%d\", ($ram_used / $ram_total) * 100}")
ram_col=$(pct_color "$ram_pct")

temp_col=$(temp_color "$temp")
temp_display="${temp}°C"
[[ "$temp" == "N/A" ]] && temp_display="N/A"

# FIX #5: normalise temp to an integer for safe numeric comparisons;
# use 0 when temp is N/A so all ((temp_int >= N)) tests safely return false.
temp_int=0
[[ "$temp" =~ ^[0-9]+$ ]] && temp_int=$temp

# ── Compose Waybar JSON output ───────────────────────────────────────────────

# FIX #2: label now says KiB/s to match the actual math
text="\
󰍛 ${core_bar_text} \
󰘚 <span foreground='${ram_col}'>${ram_used}/${ram_total}G</span> \
󱃃 <span foreground='${temp_col}'>${temp_display}</span> \
󰇚 <span foreground='#447a27'>${wifi_dl} KiB/s</span> \
󰕒 <span foreground='#447a27'>${wifi_ul} KiB/s</span> \
"

tooltip_header="<b>System Monitor</b>\n\n"
tooltip_cpu="<b> CPU — ${num_cores} cores</b>\n${core_lines}\n"
tooltip_ram="<b> RAM</b>\n<span foreground='${ram_col}'>${ram_used} GiB used / ${ram_total} GiB total  (${ram_pct}%)</span>\n\n"
tooltip_temp="<b>󰔄 Temperature</b>\n<span foreground='${temp_col}'>${temp_display}</span>\n\n"
tooltip_wifi="<b>󰇚 WiFi</b>\n<span>${wifi_dl} KiB/s ↓ ${wifi_ul} KiB/s</span>"
tooltip="${tooltip_header}${tooltip_cpu}${tooltip_ram}${tooltip_temp}${tooltip_wifi}"

# Determine overall class for CSS theming
# FIX #5: use $temp_int so numeric comparison is always safe
if ((ram_pct >= 90)) || ((temp_int >= 90)); then
	css_class="critical"
elif ((ram_pct >= 70)) || ((temp_int >= 75)); then
	css_class="warning"
else
	css_class="normal"
fi

# FIX #6: use jq for safe JSON serialisation — handles quotes, newlines,
# Pango markup characters, and any other special chars automatically.
jq -cn \
	--arg text "$text" \
	--arg tooltip "$(printf '%b' "$tooltip")" \
	--arg class "$css_class" \
	'{text: $text, tooltip: $tooltip, class: $class}'
