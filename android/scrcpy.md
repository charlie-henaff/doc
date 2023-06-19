# scrcpy 

pronounced "screen copy"

This application mirrors Android devices (video and audio) connected via USB or over TCP/IP, and allows to control the device with the keyboard and the mouse of the computer. It does not require any root access. It works on Linux, Windows and macOS.

- [github](https://github.com/Genymobile/scrcpy)

## Scripts

### tel.sh
```sh
#!/bin/bash
# scrcpy all phones found in adb devices 
phone_ids=$(adb devices | tail -n +2 | cut -sf 1)
i=0;
for phone_id in $phone_ids;
do 
	scrcpy-noconsole -s $phone_id &
	if [$i<${#$phone_ids[@]}]; then sleep 2; fi
	$i++
done
```
