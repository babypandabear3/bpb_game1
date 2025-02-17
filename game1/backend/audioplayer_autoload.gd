class_name AutoloadAudioPlayer
extends Node

const HOVER = "res://sound/sfx_menu/001_Hover_01.wav"
const CONFIRM = "res://sound/sfx_menu/013_Confirm_03.wav"
const DECLINE = "res://sound/sfx_menu/029_Decline_09.wav"
const DENIED = "res://sound/sfx_menu/033_Denied_03.wav"
const USE_ITEM = "res://sound/sfx_menu/051_use_item_01.wav"
const EQUIP = "res://sound/sfx_menu/070_Equip_10.wav"
const UNEQUIP = "res://sound/sfx_menu/071_Unequip_01.wav"
const BUY_SELL = "res://sound/sfx_menu/079_Buy_sell_01.wav"
const PAUSE = "res://sound/sfx_menu/092_Pause_04.wav"
const UNPAUSE = "res://sound/sfx_menu/098_Unpause_04.wav"

func sfx_hover():
	SodaAudioManager.play_snd_interface(HOVER)
	
func sfx_confirm():
	SodaAudioManager.play_snd_interface(CONFIRM)

func sfx_decline():
	SodaAudioManager.play_snd_interface(DECLINE)
	
func sfx_denied():
	SodaAudioManager.play_snd_interface(DENIED)
	
func sfx_use_item():
	SodaAudioManager.play_snd_interface(USE_ITEM)
	
func sfx_equip():
	SodaAudioManager.play_snd_interface(EQUIP)
	
func sfx_unequip():
	SodaAudioManager.play_snd_interface(UNEQUIP)
	
func sfx_buy_sell():
	SodaAudioManager.play_snd_interface(BUY_SELL)
	
func sfx_pause():
	SodaAudioManager.play_snd_interface(PAUSE)
	
func sfx_unpause():
	SodaAudioManager.play_snd_interface(UNPAUSE)
	
