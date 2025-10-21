#Requires AutoHotkey v1

#SingleInstance Force

#include <HeckerFunc>

;-------------------------------------------------------

showTooltip := true
tooltipVisibleTime := 1000

volumeChangeRatio := 0
volumeChange := 0

;-------------------------------------------------------
; Settings

; Increase/decrease/mute the default sound device's volume
Hotkey #+WheelUp, increaseVolume
Hotkey #+WheelDown, decreaseVolume
Hotkey #+MButton, muteVolume
;Turn on/off tooltip feedback about volumeController actions
Hotkey #!MButton, toggleVolumeTooltip

; The amount of which the the volume changes. Default: 5 (only applies if "changePercentage" is 0 or not defined)
volumeChange = 5
; The percentage of which the the volume decreases (increase: 1/changePercentage). If 0 or not defined, the volume changes by a fixed amount. Default: 0
volumeChangePercentage = 90

;-------------------------------------------------------

volumeChangeRatio := volumeChangePercentage / 100

;-------------------------------------------------------
;-------------------------------------------------------

increaseVolume() {
	global volumeChange
	global volumeChangeRatio
	global showTooltip ;Set in toggleVolumeTooltip
	global tooltipVisibleTime ;Set at the beginning of the script

	soundGet currentVolume
	if(volumeChangeRatio == 0)
		SoundSet +%volumeChange%
	else
		SoundSet % currentVolume == 0 ? 1 : currentVolume / volumeChangeRatio

	soundGet currentVolume
	if(showTooltip)
		tmpToolTip(round(currentVolume), tooltipVisibleTime)
}

decreaseVolume() {
	global volumeChange
	global volumeChangeRatio
	global showTooltip ;Set in toggleVolumeTooltip
	global tooltipVisibleTime ;Set at the beginning of the script

	soundGet currentVolume
	if(volumeChangeRatio == 0)
		SoundSet -%volumeChange%
	else
		SoundSet % currentVolume == 0 ? 1 : currentVolume * volumeChangeRatio

	SoundGet currentVolume
	if(showTooltip)
		tmpToolTip(round(currentVolume), tooltipVisibleTime)
}

muteVolume() {
	global showTooltip ;Set in toggleVolumeTooltip
	global tooltipVisibleTime ;Set at the beginning of the script

	SoundGet, soundOn, , MUTE
	SoundSet, +1, , MUTE

	if(showTooltip)
		tmpToolTip("Sound " . soundOn, tooltipVisibleTime)
}

toggleVolumeTooltip() {
	global showTooltip ;Global value to set here

	showTooltip := !showTooltip
}
