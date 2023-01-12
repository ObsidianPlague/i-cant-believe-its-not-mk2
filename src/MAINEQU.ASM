**************************************************************************
*												*
*  video game project:	  mortal kombat 2							*
*												*
*  programmer:		  edward j. boon							*
*												*
*  module: mainequ.asm --  main equate file						*
*												*
*  copyright (c) 1993 williams electronics games, inc.				*
*												*
**************************************************************************

	.global	xlate_table

	.global	ELEC_P,JADE_P
	.global	bgndpaltbl,end_of_bakram
	.global	adv_winner_map
	.global	morph_swpal

	.global	JXVICTORY8B,JXVICTORY8D
	.global	a_explode,test_oinit,a_bigstone,a_lilstone,KAHNBIG1
	.global	ziptest,RDEND
	.global	INSERTCOIN,make_player_obj
	.global	LKSTANCE1A,LKSTANCE1B,JCSTANCE1A
	.global	BIGRP1,SPEARHIT,mtv_style
	.global	huge_mk_logo,dlists_bogus
	.global	amode_demo_scroll
	.global	amode_fade_retp,character_anitabs1

	.global	baby_flash,baby_poof


	.global	debug1,debug2,debug3
	.global	debug4,debug5,debug6
	.global	do_spear
	.global	wdmatest,TMAURA1
; TEMP

	.global	SCORE_P,LIFEBOX


* mk?.asm
	.global	hat_anitab1,hat_anitab2
	.global	lk_anitab1,lk_anitab2
	.global	jc_anitab1,jc_anitab2
	.global	sa_anitab1,sa_anitab2
	.global	fn1_anitab1,fn1_anitab2
	.global	fn2_anitab1,fn2_anitab2
	.global	st_anitab1,st_anitab2
	.global	rd_anitab1,rd_anitab2
	.global	sc_anitab1,sc_anitab2
	.global	sz_anitab1,sz_anitab2
	.global	rp_anitab1,rp_anitab2
	.global	jx_anitab1,jx_anitab2
	.global	go_anitab1,go_anitab2
	.global	sk_anitab1,sk_anitab2
	.global	sm_anitab1,sm_anitab2
	.global	fn3_anitab1,fn3_anitab2

	.global	JCVICTORYLEG1A,JCVICTORYLEG1B

* mkdisp.asm
	.global	scrtst,floor_code,clock_nums,LIFEBOX,skew_rets
	.global	delobj_lista4
	.global	delobj2,delobj3,scrntl2,objlst2,objlst3,baklst8,ganiof
	.global ofree,worldtlx,ani,scrnlr,scrntl,ani_flag,objlst
	.global insobj2,insobj3,displayon,objstr,setup_score_ram,existobj
	.global	insobj,getobj,delete_shadow,worldtlx8,worldtlx7
	.global worldtlx6worldtlx5,worldtlx4,worldtlx3,worldtlx2,worldtlx0
	.global	gsagof,scrnlr2,display
	.global worldtlx6,worldtlx5,delobj,last_objlst,dma_interupt
	.global	scrollx,grab_screen,update_pmsg
	.global	scrolly,qdman,worldtly,oinit,qdma
	.global	baklst1,scrollx0,scrollx2,scrollx3,scrollx4,scrollx5,scrollx6
	.global	scrollx7,scrollx8,yzsort
	.global	baklst2,baklst3,baklst4,baklst5,baklst6,baklst7,insobj_v
	.global	bkgsagof,dman,kilobj,kilobj2,ani0
	.global	update_knotches,dlists,score_nums_tbl
  	.global	battle_numbers

	.global	TMSTANCE1,LKSTANCE1,JCSTANCE1,UGSTANCE1,KT1STANCE1,KT2STANCE1
	.global	STSTANCE1,RNSTANCE1,NJ1STANCE1,NJ2STANCE1,NJ3STANCE1,JXSTANCE1


* mkguys.asm
	.global	character_palettes_1,character_palettes_2
	.global	setup_players,make_player_1_obj,make_player_2_obj
	.global	death_fade_excludes,change_to_bloody_pal
	.global	get_char_ani,get_char_ani2
	.global	ochar_froze_pals,ground_ochar
	.global	player_normpal,player_swpal,player_froze_pal
	.global	get_walk_info_b,get_walk_info_f,KT2BLUD_P
	.global	smoke_info,jade_info

* mkinit.asm
	.global	p2_amode_block,p1_start_button
	.global	p1_amode_block,p2_start_button
	.global	POWERRET,mainlp,set_game_volume

* mktoast.asm
	.global	jade_check,toasty_check,noob_check

* mkdrone.asm
	.global	drone_post_skull_hit
	.global	drone_stance_setup
	.global	drone_1_proc,drone_2_proc,drone_beware
	.global	drone_entry,drone_post_duck_hit,drone_getup
	.global	drone_post_block,drone_land,drone_finish_him,is_he_him
	.global	kahn_stalk_a11,speedy_entry,get_his_proj_proc
	.global	drone_bf_jsrp,drone_retreat,drone_approach,stance_wait_yes
	.global	goro_walk_wait_yes,goro_walk_wait_yes,is_towards_me

	.global	count_q_repeats,random_do,is_towards_me,goro_walk_wait_yes
	.global	wait_proj_spawn,am_i_way_ahead,ask_mr_diff,wait_proj_pass
	.global	is_he_attacking,dwait_turn,how_do_i_react,is_he_close_ground
	.global	return_to_beware,stance_wait,get_diff_word
	.global	is_he_done_attacking,drone_walkf_setup,will_he_reach_me
	.global	dont_walk_into_it,drone_stance_wait
	.global	is_he_grounded,react_jump_table,drone_turnaround
	.global	drone_walkb_setup,drone_zap_jump

* mkboss.asm
	.global	kahn_counter_all
	.global	kahn_start
	.global	kahn_stalk
	.global	kahn_taunt
	.global	kahn_post_dont_walk
	.global	goro_counter_all
	.global	goro_stalk,goro_slam,stop_abusive_attackers

* mkamode.asm
	.global	amode,amode_display_reset,gover_amode_entry,one_story_screen
	.global	amode_fade_retp,amode_fadein,play_pong,page_0_zip_setup
	.global	joy_show_rankings

* mkend.asm
	.global	mk2_design_team,cast_of_characters,msg_rise,mk2_team_photos
	.global	oct_team_photos

* mkfall.asm
	.global	falling_down_the_pit

* mksound
	.global	triple_sound,triple_sound2
	.global	send_code_a3,nosounds,soundup
	.global	clear_sound_ram,psound_for_him
	.global	p1p2_sound,orb_hit_sound,disturbing_scream
	.global	full_volume,randsnd,randsnd2,rsnd_react_voice

	.global	ochar_sound
	.global	random_triple
	.global	punch_sounds,kick_sounds
	.global	sweep_sounds
	.global	rsnd_wasted_voice
	.global	rsnd_death_voice
	.global	rsnd_attack
	.global	rsnd_ground
	.global	rsnd_whoosh
	.global	rsnd_smack
	.global	rsnd_big_smack
	.global	rsnd_tripped_voice
	.global	rsnd_block
	.global	rsnd_body_hit
	.global	rsnd_face_hit
	.global rsnd_smack
	.global	rsnd_grab_voice
	.global	rsnd_throw_voice

* mkbug.asm
	.global	system_lockup,dpystrt,mk2_court
	.global	TVPATCH,TVPATCHX

* mkutil.asm
	.global	audit_event_check,center_around_me,is_he_helpless
	.global	inc_a0_word,freeze_2_pages,if_boss_branch,if_not_boss_branch
	.global	goro_pick_ani,is_he_a_boss,am_i_a_boss,boss_pick_ani
	.global	am_i_close_to_edge,is_he_close_to_edge
	.global	back_to_shang_check,start_shadows
	.global	get_tsl,update_tsl,ground_multi
	.global	change_oid_list,move_object_list,p1p2_pick
	.global	clear_shadow_bit,get_char_long,ochar_jump,ochar_call
	.global	get_char_word,get_my_height
	.global	sans_boonpal,all_palettes
	.global	clear_p_ram,screen_half_a0
	.global	show_scores,dont_show_scores,set_dmawnz,set_dmacnz
	.global	set_inviso,clear_inviso
	.global	do_next_a11_for_a10,lineup_1pwm
	.global	get_his_matchw,get_my_matchw

	.global	multi_adjust_xy,adjust_him_x,adjust_xy_a5,damage_to_him
	.global	adjust_him_xy,adjust_him_tbl,adjust_him_a0

	.global	get_his_dfe,get_my_dfe,get_his_dog,distance_off_ground
	.global	get_his_dfeos,get_my_dfeos
	.global	get_multi_obj,get_single_obj
	.global	gso_dmawnz_ns,gso_dmawnz,gso_dmacnz,gmo_proc,multi_dummy_wake
	.global	kmo_proc,sync_wait_dma_q
	.global	do_his_next_a9_frame,find_ani_last_frame
	.global	find_last_frame
	.global	do_first_a9_frame,shake_him_up,mframew_him
	.global	get_his_char_ani,get_his_char_ani2
	.global	pose_him_a0,ground_him,away_x_vel_him,get_his_char_word
	.global	get_his_char_long

	.global	match_him_with_me_f
	.global	match_him_with_me,match_me_with_him

	.global	set_noflip,set_no_block,get_his_action
	.global	center_obj_x
	.global	delobjp,delolist,wait_forever,set_xy_coordinates,insobja8
	.global	display_on,murder_myoinit_score,murder,murder_myoinit
	.global	page_0_setup,view_page_1,view_page_0,null_image
	.global	page_0_setup_no_init
	.global	drone_kill_init,fastxfer,make_solid_object,swpal,score_b0

	.global	olist_noscroll
	.global	fade_all_sky,initobj,set_noscroll,exprc_er,killfx,boonpal_stuff
	.global	frame_a9,double_compare,delobjp2,dallobj,dallprc
	.global	nrgbs0
	.global	insobj3a8,insobj2a8,reset_proc_stack,display_off
	.global	create_if_gone,exprc,delete_multi,do_next_a9_frame
	.global	face_opponent,back_to_normal,is_he_right,am_i_shang
	.global	takeover_him,takeover_him_sr
	.global	backwards_ani
	.global	mframew,find_ani_part2,match_ani_points,ground_player
	.global	animate_a9,animate2_a9,pose_a9,pose2_a9
	.global	highest_mpart,next_anirate,mframew,delete_slave,get_my_strength
	.global	get_his_strength
	.global	clear_slave_ram
	.global	act_mframew,init_anirate
	.global	flipped_pause,create_and_kill,set_all_worldtlx
	.global	find_part2,animate_a0_frames,find_part_a14
	.global	flip_multi,flip_multi_v,flip_single
	.global	initobj,lowest_mpart,set_x_woff,wait_for_start,rightmost_mpart
	.global	wait_for_landing,wait_for_his_dog
	.global	leftmost_mpart,gravity_ani,ani2,a5a6ol2,a5a6ol3,initobj_3
	.global	framew_a10a11,framew
	.global	cycle_forward,clear_ram
	.global	double_mframew,double_next_a9
	.global	zero_table_o_words,zero_table_o_longs
	.global	solid_object_img
	.global	distance_from_ground,getblimp
	.global	calla_for_him
	.global	am_i_short,is_he_short,frame_a10a11

* ram.asm
	.global	l_hp,l_lp,l_block,l_hk,l_lk
	.global	p1proj_ram,p2proj_ram
	.global	p2_obj,pageaddr,f_novel,score_1st,p2_matchw
	.global	p1_knotch1,p1_knotch2,left_edge,p2_knotch1,p2_knotch2,p1_proc
	.global	p1_bar_view,p2_bar_view,p2_bar_xpos
	.global	right_edge,p2_proc,p1_bar,p2_bar,p1_char,p1_matchw
	.global	p1_obj,ground_y,c_amode_bio,map_start
	.global	toasty,f_secret,c_1p_tries

; are all these needed ? **********************************************
	.global	entry_5,entry_6,entry_9,entry_10
	.global	entry_1,entry_13,entry_14,entry_15,entry_16,entry_17
	.global	entry_18,entry_19,entry_20
; are all these needed ? **********************************************

	.global	score_ram_end,p2_char,noflip,f_doscore
	.global	f_auto_erase,f_thatsall
	.global	p1_score,f_start,p2_score,c_drone_kill,f_norepell
	.global	p2_button,c_amodeloop,f_nosound,irqskye,gstate
	.global	p1_button,swstmn,swstack,swstst
	.global	syscopy,silhoette,f_no_lb,f_no_violence,tick
	.global	p1_state,f_no_blood,irqled,swtemp1
	.global	swtemp2,swtemp3,swtemp4,nplayers,p2_state,p1_shape
	.global	p2_shape,palram,intsync1,p2_xvel
	.global	curback,round_num,p1_hitq
	.global	perform,f_timeout,p2_hitq,c_three
	.global	c_goro_wins,map_position
	.global	p1_perfect,pf_ram,p1_wiar
	.global	p1_rwon,p2_rwon
	.global	f_fade,f_warnsound,p2_wiar,winner_status
	.global	p2_perfect,f_death,f_death2,clk_ones,battle_num
	.global	p1_xvel,clk_tens,p1_map,f_start_pressed,diff
	.global	scrtab,ceiling_y,ptrram,bpalram,fpalram
	.global	p1_ram,p2_ram,f_nopmsg,counter_copy,counter_copy
	.global	f_shadows,f_colbox,p1_shadadj,p2_shadadj
	.global	c_p1p2_fastblk,l_spin,l_drone_slam,f_pit_fall

	.global	p1_bcq,p1_jcq,p1_boq,p1_joq
	.global	p2_bcq,p2_jcq,p2_boq,p2_joq

	.global	skew_dx,skew_oc,f_skew,skew_y,skew_height,skew_stack,skew_sag
	.global	skew_constpal,skew_scroll,skew_calla

	.global	l_spear,l_gslam,l_warp,l_gpounce,l_drone_fk,l_decoy
	.global	l_gorofire,l_drone_zap,l_slide,l_throw_fan
	.global	l_morph
	.global	l_pud,l_kano,f_sans_throws,f_show_ranking

	.global	call_every_tick,c_goro_dummy,c_sk_taunt,c_kahn_dummy

;*********** debug ram
	.global	f_countpix,pixel_count,last_dma,f_do_psel,f_fastrun
;*********** debug ram

* pall.asm
	.global	getfpal,freepal,findpal,palset,delpal,transfer_palettes
	.global	clrpal,blowpal,getbpal

* util.asm
	.global	myoinit,fadeout,skydown,stop_a8,srand,randu,fadein
	.global	fadeblak,dmawait,clr_scrn,scrclr,random,setpproc,join_in_fade2
	.global	join_in_fade1,randper,fade_all_fast,blnkarea,fillarea
	.global	fade_all,raiden_dimmer,raiden_undimmer

* bgnd.asm
	.global	background,do_a11_background,table_o_mods
	.global	forden_peek,danger,initials1_mod,initials2_mod
	.global	pit_scroll,scroll_center,ceiling_scroll,spike_the_ceiling

	.global	myoinit,fadeout,skydown
	.global	stop_a8,init_bakmods,randu
	.global	randu
	.global	fadein,fadeblak
	.global	fadeblak,multi_plane,dmawait,clr_scrn
	.global	clr_scrn,demo_scroll,scrclr,random
	.global	random,setpproc,scroller,join_in_fade2
	.global	join_in_fade2,join_in_fade1,stop_scrolling,randper
	.global	randper,blnkarea,fillarea
	.global	psel_mod,buyin_mod,dlists_objlst,huge_mod,vs_mod,hstd_mod
	.global	coin_page_bgnd

	.global	PITFLOOR,pitcrack,pitcloud
	.global	pitblood1a,pitblood1b,pitblood2a,pitblood2b
	.global	r_fall_in_slime


* mkhstd.asm
	.global	drawbox,print_rankings,enter_initials,does_a0_cut_it
	.global	check_hstd_cmos

* mktext.asm
	.global	rd15font,rd7font,rd11font,p15_2s,p15_3s,font15_nums
	.global	MK2FONT1,MK2FONT2,vfont1,vfont2

* bakgnd.asm
	.global	bakclr,bak3bits,bak4bits,bak5bits,bak0mods,dumbgnd,bak6bits
	.global	bak1mods,bak7bits,bak2mods,bak8bits,bak3mods,bak4mods,bak5mods
	.global	bgnd_ud1,bak6mods,bak7mods,bak8mods,bak1bits,bak2bits

* joy.asm
	.global	is_he_blocking,bt_jump
	.global	xfer_otherguy,do_duck_kickl,do_sweep_kick,do_duck_kickh
	.global	retract_strike,do_jumpup_kick,do_uppercut,do_lo_kick
	.global	do_duck,do_backup,do_duck_block
	.global	do_hi_kick
	.global	is_he_airborn,stance_setup,get_char_ani,get_char_ani2
	.global	damage_to_me,reaction_exit
	.global	stop_me,disable_his_buttons,stop_him
	.global	bt_null,joy_2_proc,joy_1_proc
	.global	joy_down,joy_up
	.global	joystick_in_a0,joy_back_up
	.global	noflip_a2,striker,joy_getup_entry
	.global	am_i_airborn,disable_all_buttons
	.global	strike_check,joy_entry,am_i_him,am_i_joy
	.global	is_stick_away,is_stick_down

	.global	joy_duck_block_loop
	.global	joy_block_loop

	.global	stuff_buttons,upcut_striker
	.global	striker,striker_2,behind_striker
	.global	me_in_front,me_in_back
	.global	set_x_vel,is_he_facing_me,am_i_facing_him
	.global	strike_check_a0,check_winner_status
	.global	get_x_dist,get_y_dist
	.global	react_xfer_him,get_walk_speeds,do_jump_up
	.global	next_flip_whoosh,is_he_joy

* main.asm
	.global	SETUP,post_sec_trash,if_amode_die
	.GLOBAL	TMSTANCE1A,UGSTANCE1A,KT2STANCE1A,STSTANCE1A,RNSTANCE1A
	.global NJ1STANCE1A,NJ2STANCE1A,NJ3STANCE1A,JXSTANCE1A
	.global	all_palettes,amode_demo_game,flash_pmsg,who_is_alone
	.global	init_player_variables,who_is_next,flash_pmsg2
	.global	repell,start_shadows,count_active_players
	.global	congrats,get_winner_ochar
	.global	is_final_boss_playing,play_1_round
	.global	inc_winners_wiar,update_win_counters
	.global	bonus_count,end_of_match_chores,results_of_round
	.global	game4,loser_in_buyin,play9

	.global	wait_fatality_finish,finish_him_exit
	.global	fatality_waiting

* mkbuyin.asm
	.global	do_buyin,eliminate_buyins

* moves.asm
	.global	lk_zapair
	.global	do_fatality_1,do_fatality_2
	.global	do_lk_super,do_raiden_dive,do_spinfan,do_shred
	.global	switch_close_jumps,switch_open_jumps
	.global	get_char_stk,do_flip_punch
	.global	do_flip_kick,do_duck_punch,do_body_slam,do_roundhouse
	.global	do_jumpup_punch,do_knee,do_elbow,do_throw_hat
	.global	do_swipe,do_jc_pp,do_fan_swipe
	.global	set_proj_vel,flight_call,flight,flight_loop
	.global	away_x_vel,do_unblock_hi,do_block_hi
	.global	get_bcq_next_pointer,previous_q_entry
	.global	towards_x_vel,raiden_dragging,do_land_animation
	.global	air_init_special,init_special,init_special_act
	.global	turn_around,duck_turnaround
	.global	drone_do_a0,ta_speeds,r_scissor
	.global	button_bit_check,suspend_wait,shocker_lineup,shocker_shaker
	.global	restricted_xfer,combo_look_lr,do_inviso
	
	.global	do_noogy

	.global	pf_change,bb_check,fs_check,start_bounce,disco_ball_proc
	.global	do_babality,do_friendship,toasty_check

* mkprop.asm
	.global	do_body_propell

* mkslam.asm
	.global	do_air_body_slam,do_back_breaker

* mkzap.asm
	.global	do_zap,get_proj_obj_m,spawn_proj_proc,proj_onscreen_test
	.global	delete_proj_and_die

* mkreact.asm
	.global	attacker_getting_separated,post_broken_back
	.global	super_ags
	.global	r_bike_kicked_done,r_null_speared
	.global	tossed_by_hathead,fall_on_my_back,post_fanned
	.global	post_fb_xfers,r_post_dived,r_quake
	.global	raiden_getup_pal,get_my_hitq,r_last_noogy
	.global	shake_n_sound,raiden_getup_pal,getup_local_reaction_exit
	.global	slammed_by_goro,get_block_ani_offset
	.global	drone_beware_mframew,raiden_getup_pal
	.global	check_sk_death,get_his_floor_ice

* mksel.asm
	.global	menu_to_ochar,ochar_to_menu,init_map_start
	.global	do_ladder,setup_ladder_screen,vs_screen
	.global	player_select,show_credits,join_in_during_psel,mysterybox
	.global	psel_cursor_loop,auto_player_select

* mkfx.asm
	.global	mk2_intro,fx_toasty,white_flash,danger_danger,green_soul
	.global	shake_a11,grow_msg,pp_number,trail_proc,fx_charge_bars
	.global	fx_inviso_flame,kiss_explode,spit_smoke,kang_smoke
	.global	fx_inviso_flame2
	.global	mk2_morph_in,amode_coinpage_mk2,drain_table,scorpion_flame
	.global	smoke_a_guy,smoke_a_guy4
	.global	a_scorpion_flame,double_flame_ani
	.global	boss_die_sequence

	.global	a_final_drain,alternate_suck_pals
	.global	HHDRAIN0
	.global	LKDRAIN0
	.global	JCDRAIN0
	.global	SADRAIN0
	.global	FNDRAIN0
	.global	STDRAIN0
	.global	RDDRAIN0
	.global	NJDRAIN0
	.global	JXDRAIN0

* react.asm
	.global	reaction_tables
	.global	block_xfers,torso_bounce


* mkcanned.asm
	.global	player_1_wins,player_2_wins,finish_him,dizzy
	.global	victory_animation,decap_fall,r_stabbed_by_fn2
	.global	back_to_shang_form,tongued_fall,dizzy_dude	;,decapped_head
	.global	cage_poped_fall,kahn_death,r_hat_decap

* mkdie.asm
	.global	r_kissed,r_body_suck,spit_bones
	.global	r_burst_pop,inflate_pose,r_shocker_pop,r_raiden_superp
	.global	ochar_arm_ripped_ani,BLDSPLASH1,kahn_explode,a_snowball
	.global	r_pitched

* bgndpal.asm
	.global	WATER		; color cycle palette for Goskie zone

* mkblood.asm
	.global	MIDPR5,create_blood_proc,blood_fall

* mkdeath.asm
	.global	mkcomdisk
	.global	db1_table,db2_table,r_super_freeze,do_shatter_punch
	.global	r_shatter_punch,do_super_freeze,super_frozen
	.global	init_death_blow,death_blow_complete
	.global	do_down_the_pit,super_freeze_bang,big3,FREEZE_P
	.global	do_up_the_spike,do_kintaro_fatal

* unzip.asm
	.global	movie_run,zipped_pics,show_a0_ending,show_rev_x,show_dcs_logo

* diag*.*
	.global	fs_inits,menu_initials,menu_move_sound,menu_select_sound
	.global	amode_coin_page,diag_jump,mk_octo_menu
	.global	get_adj,put_adj,go_volume,sec_random_trash

	.global	cr_strtp, cr_contp, p_start, p_cont, cr_both,get_credits
	.global	get_cstr,should_i_fade_dragon,secbust_proc,clear_units

**************************************************************************
*											     *
* 	switch bits									     *
*											     *
**************************************************************************

p1b0	.set	00000000000000000000000000010000b
p1b1	.set	00000000000000000000000000000001b	; switch 2
p1b2	.set	00000000000000000000000000100000b
p1b3	.set	00000000000000000000000001000000b
p1b4	.set	00000000000000000000000000000010b   ; switch 2
p1sf2	.set	10000000000000000000000000000000b

p2b0	.set	00000000000000000001000000000000b
p2b1	.set	00000000000000000000000000010000b   ; switch 2
p2b2	.set	00000000000000000010000000000000b
p2b3	.set	00000000000000000100000000000000b
p2b4	.set	00000000000000000000000000100000b   ; switch 2
p2sf2	.set	00001000000000000000000000000000b

f1b0	.set	00000000000000000000000000010000b
f1b1	.set	00000000000000000000000000000001b	; switch 2
f1b2	.set	00000000000000000000000000100000b
f1b3	.set	00000000000000000000000001000000b
f1b4	.set	00000000000000000000000000000010b   ; switch 2
f1sf2	.set	10000000000000000000000000000000b
f2b0	.set	00000000000000000001000000000000b
f2b1	.set	00000000000000000000000000000100b   ; switch 2
f2b2	.set	00000000000000000010000000000000b
f2b3	.set	00000000000000000100000000000000b
f2b4	.set	00000000000000000000000000001000b   ; switch 2
f2sf2	.set	00001000000000000000000000000000b


j1up	.set	00000000000000000000000000000001b
j1down	.set	00000000000000000000000000000010b
j1left	.set	00000000000000000000000000000100b
j1right	.set	00000000000000000000000000001000b
j2up	.set	00000000000000000000000100000000b
j2down	.set	00000000000000000000001000000000b
j2left	.set	00000000000000000000010000000000b
j2right	.set	00000000000000000000100000000000b



b_diag	.set	>14	; switch bit = diagnostics
b_vdown	.set	>1b	; switch bit = volume down
b_vup	.set	>1c	; switch bit = volume up



;p1b0	.set	00000000000000000000000000000000b
;p1b1	.set	00010000000000000000000000000000b
;p1b2	.set	00000000000000000000000000100000b
;p1b3	.set	00000000000000000000000001000000b
;p1b4	.set	00100000000000000000000000000000b
;p1b5	.set	10000000000000000000000000000000b
;p2b0	.set	00000000000000000001000000000000b
;p2b1	.set	00000010000000000000000000000000b
;p2b2	.set	00000000000000000010000000000000b
;p2b3	.set	00000000000000000100000000000000b
;p2b4	.set	00000100000000000000000000000000b
;p2b5	.set	00001000000000000000000000000000b


up_vel	.set	->a0000
up_grav	.set	>8000


bb_fatality	.set	5
pit_fatality	.set	6
fs_fatality	.set	7
spike_fatality	.set	8

pong_battle_num	.set	250

skip_bakmod	.set	1

sns 	.set	32*6	; score node size

tg_tens_yx	.set	>000900b9
tg_ones_yx	.set	>000900c7

p1d1_yx		.set	>000c0015
p2d1_yx		.set	>000c0120


scr_control	.set	>00
scr_sag		.set	>20
scr_coor		.set	>40
scr_size		.set	>60

close_to_edge	.set	>68	; this constitutes being close to the edge


floor_ice_time	.set	>60

full_strength	.set	>a1		; power bars at max

b_p1block	.set	5		; player 1 block button bit
b_p2block	.set	13		; player 2 block button bit

m_p1blocks	.set	10000000000000000000000000100000b
m_p2blocks	.set	00001000000000000010000000000000b

bit_jleft	.set	2
bit_jright	.set	3
bit_jdown	.set	1
bit_jup		.set	0

m_punch1		.set	16

m_jup		.set	1
m_jdown		.set	2
m_jleft		.set	4
m_jright		.set	8

b_jdown		.set	1

silreset		.set	40
angle_grav	.set	08000h
sqs		.set	20		; # of entries in switch queue

front_z		.set	050h
back_z		.set	04fh

never_ani	.set	>fff
dont_touch	.set	13

sf_squeeze	.set	1	; flag: squeeze
sb_squeeze	.set	0	; flag: squeeze
sf_duck		.set	2	; flag: must duck/block to block

gnull		.set	22

chop_round	.set	00fh

butns		.set	5
wy_offset	.set	0e0h		; worldtly offset


left_padding	.set	03ah
right_padding	.set	030h

ft_hathead	.set	0
ft_kang		.set	1
ft_cage		.set	2
ft_sa		.set	3
ft_fn1		.set	4
ft_fn2		.set	5
ft_st		.set	6
ft_raiden	.set	7
ft_subzero	.set	8
ft_reptile	.set	9
ft_scorpion	.set	10
ft_jax		.set	11
ft_goro		.set	12
ft_final_boss	.set	13

ft_smoke		.set	14	; SMOKE the hidden ninja character
ft_noob		.set	15
ft_jade		.set	16	; jade the bitch


*
* secret move bits
*
b_vdsplit1	.set	0
b_vdsplit2	.set	1


m_vdsplit1	.set	1
m_vdsplit2	.set	2

mm_sound		.set	221h		; menu move sound call
ms_sound		.set	224h		; menu select sound

**************************************************************************
*											     *
*     process flag equates								     *
*											     *
**************************************************************************
pb_joy		.set	0	; flag: i am a joystick controlled guy
pb_finish	.set	1	; flag: i get to finish other player off!
pb_reacting	.set	2	; flag: i am reacting to some attack
pb_sitduck	.set	3	; flag: i am a sitting duck
pb_special	.set	4	; flag: i am doing a special move (no doubles)
pb_alt_pal	.set	5	; flag: i am using an alternate palette !!
pb_corpse	.set	6	; flag: i am a wasted drone corpse
pb_emperor	.set	7	; flag: i am the emperor
pb_gninja	.set	8	; flag: i am the green ninja


* make sure you clear this if you ever let the other player
* "get his powers back" (ejbejbejb)

pm_joy		.set	001h	; flag: i am a joystick controlled guy
pm_finish	.set	002h	; flag: i get to finish other player off!
pm_reacting	.set	004h	; flag: i am reacting to some attack
pm_sitduck	.set	008h	; flag: i am a sitting duck
pm_special	.set	010h	; flag: i am doing a special move (no doubles)
pm_alt_pal	.set	020h	; flag: i am using an alternate palette !!
pm_corpse	.set	040h	; flag: i am a wasted drone corpse
pm_emperor	.set	080h	; flag: i am the emperor
pm_gninja	.set	0100h	; flag: i am the green ninja

**************************************************************************
*											     *
*     action equates									     *
*											     *
**************************************************************************

* projectile attacks
act_throw_hat	.set	>01	; throw hat
act_lkzap_lo	.set	>02	; liu kang zap lo
act_lkzap_hi	.set	>03	; liu kang zap hi
act_lkzap_air	.set	>04	; liu kang zap in the air
act_jcsnot_lo	.set	>05	; cage snot lo
act_jcsnot_hi	.set	>06	; cage snot hi
act_spark	.set	>07	; baraka sparks
act_throw_fans	.set	>08	; throw fans
act_air_fans	.set	>09	; throw fans while in the air
act_throw_tsai	.set	>0a	; throw tsai
act_air_tsai	.set	>0b	; throw tsai is the air
act_throw_skull1	.set	>0c	; throw skulls
act_throw_skull2	.set	>0d	; throw skulls
act_throw_skull3	.set	>0e	; throw skulls
act_throw_bolt	.set	>0f	; throw raiden bolt
act_throw_ice	.set	>10	; throw ice
act_spear	.set	>11	; throw spear
act_spit		.set	>12	; spit
act_slow_orb	.set	>13	; slow orb (reptile)
act_jax_zap	.set	>14	; jax throw projectile

* stationary attacks
act_attacks	.set	>100	; action catagory: attacks
act_hipunch	.set	>101	; trying to punch hi
act_lopunch	.set	>102	; trying to punch low
act_hikick	.set	>103	; trying to kick high
act_medkick	.set	>104	; trying to kick low
act_rhouse	.set	>105	; trying round house kick
act_sweep	.set	>106	; sweep kicking
act_uppercut	.set	>107	; uppercut punch
act_hhspin	.set	>108	; hathead spin
act_backbreak	.set	>109	; jax back breaker move
act_splits	.set	>10a	; splits punch
;		.set	>10b	;
;		.set	>10c	;
;		.set	>10d	;
act_jupkick	.set	>10e	; jumpup kick
act_knee		.set	>10f	; knee attack
;		.set	>110	;
;		.set	>111	;
;		.set	>112	;
act_duck_kickh	.set	>113	; duck kick
act_elbow	.set	>114	; elbow
;		.set	>115	;
;		.set	>116	;
;		.set	>117	;
act_juppunch	.set	>118	; jumpup punch
act_duckpunch	.set	>119	; duck punch low
act_duck_kickl	.set	>11a	; duck kick low
;		.set	>11b
act_2nd_knee	.set	>11c	; sword arm knee #2 attack
act_shred	.set	>11d	; shred
act_swipe	.set	>11e	; swipe
;		.set	>11f	;
act_fan_swipe	.set	>120	; fan swipe
act_sa_spin	.set	>121	; sword arm spin move
act_noogy	.set	>122	; noogy punch
;		.set	>123	;
;		.set	>124	;
;		.set	>125	;
;		.set	>126	;
;		.set	>127	;
;		.set	>128	;
;		.set	>129	;
;		.set	>12a	;
;		.set	>12b	;
act_sonic	.set	>12c	; sonic fan waves
;		.set	>12d	;
;		.set	>12e	;
;		.set	>12f	;
;		.set	>130	;
;		.set	>131	;
;		.set	>132	;
;		.set	>133	;
act_floor_ice	.set	>134	; throw ice on the floor
;		.set	>135	;
;		.set	>136	;
act_quake	.set	>137	; earthquake
;		.set	>138	;
;		.set	>139	;
;		.set	>140	;

*
* body propelling attacks
*
act_body_propell	.set	>200
act_flykick	.set	>200	; flying kick
act_flypunch	.set	>201	; flying punch
act_hh_teleport	.set	>202	; kung lao teleport
act_superkang	.set	>203	; kang super flying kick
act_bike		.set	>204	; liu kang bike kick
act_shadk	.set	>205	; cage shadow kick
act_shoruken	.set	>206	;
act_square	.set	>207	;
act_fntele	.set	>208	; female ninja teleport
act_dive		.set	>209	; raiden dive super-move !!
act_decoy	.set	>20a	; scorpion "decoy" attack
act_scissor	.set	>20b	; scissor kick
act_slide	.set	>20c	; subzero slide kick
act_reptile_fly	.set	>20d	; reptile flykick move
act_kano		.set	>20e	; kano ball move


* non-attacking actions
act_nonattacks	.set	>300
act_backup	.set	>301	; getting backup from crouch position
act_duck		.set	>302	; duck
act_stance	.set	>303	; stance
act_land		.set	>304	; landing on ground
act_walkf	.set	>305	; walk forward
act_postattack	.set	>306	; just finished an attack
act_walkb	.set	>307	; walk backward
act_angle_jump	.set	>308	; jumping at an angle
act_melt		.set	>309	; raiden melt
act_getup	.set	>30a	; getup from a fall
act_jumpup	.set	>30b	; jump straight up

* specific actions
act_stunned	.set	>400	; stunned
act_frozen	.set	>401	; frozen
act_speared	.set	>402	; speared by yellow ninja
act_shocker	.set	>403	; raiden shocker move
act_morph	.set	>404	; shang morph
act_rope_pull	.set	>405	; scorpion pulling in other guy
act_balled	.set	>406	; reacting to splits punch
act_psycho_goro	.set	>407
act_pre_shatter	.set	>408
act_hat_killer	.set	>409	; hat killer mode


* unrelated actions
act_proj_dead	.set	>500	; dead projectile
act_ignore_proj	.set	>501	; ignoring projectile
act_dead		.set	>502	; i am a dead man
act_reacting	.set	>503	; reacting to a hit
act_gflip	.set	>504	; goro flip
act_burning	.set	>505	; burning other dude (scorpion)
act_pit_fall	.set	>506	; falling down the pit !!
act_bodyslam	.set	>507	; body slam
act_spike_rise	.set	>508	; raising up to the spikes
act_wait_pud	.set	>509	; waiting for puddle
act_slime_fall	.set	>50a	; ready to fall into the slime
act_proj_passed	.set	>50b	; passed projectile


*sitting duck states
act_sweep_sd	.set	>600	; sweep sitting duck mode
act_knee_sd	.set	>601	; post knee sitting duck
act_dive_sd	.set	>602	; raiden dive sitting duck mode
act_upcut_sd	.set	>603	; post uppercut sitting duck
act_proj_sd	.set	>604	; post proj thrower sitting duck
act_speared_sd	.set	>605	; speared dude dizzy sitting duck
act_upcutted	.set	>606	; flying in the air uppercutted
act_decoy_sd	.set	>607	; post decoy sitting duck
act_shadow_sd	.set	>608	; shadow kick sitting duck !
act_hitfall_sd	.set	>609	; falling from a hit sitting duck
act_slide_sd	.set	>60a	; slide kick sitting duck
act_elbow_sd	.set	>60b	; post elbow sitting duck
act_ret_kick	.set	>60c	; retract a kick
act_fk_sd	.set	>60d	; flip kick sitting duck
act_slipping	.set	>60e	; slip sliding away (on ice)
act_spin_sd	.set	>60f	; post spin sitting duck
act_jax_dizzy	.set	>610	; dizzy by jax elbow
act_shoruken_sd	.set	>611	; shoruken sitting duck
act_fntele_sd	.set	>612	; female ninja teleport sitting duck
act_shock_sd	.set	>613	; shocked by raiden sd
act_wave_sd	.set	>614	; fanned sitting duck
act_shocker_sd	.set	>615	; raiden shocker sitting duck
act_super_froze	.set	>616	; super frozen
act_superk_sd	.set	>617	; super kang sitting duck
act_skull_sd	.set	>618	; post skull fire sitting duck
act_kano_sd	.set	>619	; kano sitting duck
act_hh_sd	.set	>61a	; kung lao superkick sd
act_orb_sd	.set	>61b	; orb sd



* blocks
act_blocks	.set	>700
act_blockhi	.set	>700	; trying to block high
act_blocklo	.set	>701	; trying to duck block


; when adding more, add entries to the tables in drone.asm

**************************************************************************
*											     *
*  joystick/button equates								     *
*											     *
**************************************************************************
sw_hi_punch	.set	0	; if this changes look for all occurances
sw_lo_punch	.set	1
sw_block		.set	2
sw_hi_kick	.set	3
sw_lo_kick	.set	4
sw_up		.set	5
sw_down		.set	6
sw_left		.set	7
sw_right		.set	8
sw_skip		.set	9

**************************************************************************
*											     *
*      score equates									     *
*											     *
**************************************************************************
sc_2000000	.set	000020001h
sc_1000000	.set	000010001h
sc_500000	.set	000050002h
sc_200000	.set	000020002h
sc_100000	.set	000010002h
sc_50000		.set	000050003h
sc_20000		.set	000020003h
sc_10000		.set	000010003h
sc_5000		.set	000050004h
sc_2000		.set	000020004h
sc_1000		.set	000010004h
sc_500		.set	000050005h
sc_200		.set	000020005h
sc_100		.set	000010005h


**************************************************************************
*												*
*		 handy dandy rgb color value equates				*
*												*
**************************************************************************
rgb_black	.set	00000h		; pitch fucking black
rgb_red		.set	07c00h		; blood red
rgb_blue 	.set	0001fh		; blue
rgb_white	.set	07fffh		; white
rgb_grey		.set	0001100011000110b ; game over grey
rgb_yellow	.set	0111111111100000b	; yellow
rgb_green	.set	0000001110000000b	; green
rgb_dark_blue	.set	0000ah		; dark blue


bpal_flash1	.set	>0101		; boonpal flash color #1
bpal_flash2	.set	>0202		; boonpal flash color #2
bpal_flash3	.set	>0303		; boonpal flash color #3
bpal_hot_purple	.set	>0404		; boonpal hot purple
bpal_purple	.set	>0505		; boonpal purple
bpal_green	.set	>0606		; boonpal green
bpal_hot_green	.set	>0707		; boonpal hot green
bpal_bar_color	.set	>0808		; boonpal strength bar color
;bpal		.set	>0909		;
;bpal		.set	>0a0a		;
bpal_blue	.set	>0b0b		; boonpal blue
bpal_yellow 	.set	>0c0c		; boonpal yellow
bpal_red 	.set	>0d0d		; boonpal red
bpal_white 	.set	>0e0e		; boonpal white
bpal_black 	.set	>0f0f		; boonpal black


end_stuff	.set	08000h		; marks end of "rbg" table

ani_jump		.set	1		; animation script "jump" command
ani_flip		.set	2		; animation script "flip" command
ani_adjustx	.set	3		; animation script "adjust x" command
ani_adjustxy	.set	4		; animation script "adjust xy" command
ani_nosleep	.set	5		; animation script "skip sleep" command
ani_calla	.set	6		; animation script call routine (next long)
ani_sound	.set	7		; animation script make a sound call
ani_ochar_jump	.set	8		; animation script ochar conditional jump
ani_flip_v	.set	9		; animation script vertical flip
ani_lastcom	.set	9		; last animation command

ps_active	.set	1		; player state: active
ps_buyin		.set	2		; player state: buyin
ps_psel		.set	3		; player state: selecting a fighter
ps_post_psel	.set	4		; player state: selected a fighter
; when adding entries, add to jump table

**************************************************************************
*												*
*			  process id's                                  *
*												*
**************************************************************************
pid_george	.set	0	; G to the N to the P

*
* constant running procs
*
pid_p1		.set	1	; player 1 process (be careful if these
pid_p2		.set	2	; player 2 process  variables are changed)
pid_master	.set	3	; master game flow process
pid_scroll	.set	4	; scroll process
pid_backg	.set	5	; background process
pid_bani		.set	6	; background object animator
pid_repell	.set	7	; repell players proc
pid_lightning	.set	8	; raiden lightning accompany
pid_flasher	.set	9	; player message flasher
pid_p1sel	.set	>0a	; player 1 select process
pid_p2sel	.set	>0b	; player 2 select process
pid_cred		.set	>0c	; show credits proc
pid_initials	.set	>0d	; enter initials proc
pid_amode	.set	>0e	; attract mode process
pid_cycle	.set	>0f	; color cycler
pid_oct		.set	>10	; octopus
pid_inviso1	.set	>11	; player 1 inviso proc
pid_inviso2	.set	>12	; player 2 inviso proc
pid_floor_ice1	.set	>13	; floor ice proc p1 
pid_floor_ice2	.set	>14	; floor ice proc p2
pid_super_slam	.set	>15	; jax super slam scanning proc
pid_danger1	.set	>16	; player 1 danger proc
pid_danger2	.set	>17	; player 2 danger proc
pid_smoker	.set	>18	; proc to constantly smoke a dude
pid_1_puff	.set	>19	; 1 puff o smoke
pid_pong_speed	.set	>1a	; pong speed up
pid_green_splash	.set	>1b	;
pid_auto_cycle	.set	>1c	; auto select color cycler

*
* 100 = special effects procs
*
pid_fx		.set	>100	; generic special f/x
pid_fade		.set	>101	; fade proc
pid_grow		.set	>102	; fx grower proc
pid_shaker	.set	>103	; earth shaker proc
pid_trail	.set	>104	; body trail (shadow kick)
pid_decoy	.set	>105	; scorpion decoy proc
pid_jc_shadow1	.set	>106	; cage shadow "borrow" proc for player 1
pid_jc_shadow2	.set	>107	; cage shadow "borrow" proc for player 2
pid_selspeech	.set	>108	; player select speech proc
pid_mpo		.set	>109	; multipart object process
pid_melt		.set	>10a	; raiden melt decoy animator proc
pid_hhdecoy	.set	>10b	; hathead decoy
pid_bones	.set	>10c
pid_poof		.set	>10d	; reptile poof proc
pid_sonic	.set	>10e	; sonic wave proc
pid_forden	.set	>10f	; forden peeker

*
* 200 = procs which control prop objects
*
pid_blood	.set	>201	; blood spirts
pid_head		.set	>202	; decapped head

*
* 300 = switch spawned procs
*
pid_switch1	.set	>300	; switch spawned process !!
pid_switch2	.set	>301	; switch spawned process !!

*
* 700 = player 1 projectile procs
*
pid_proj1	.set	>700	; generic projectile !!
pid_hat1		.set	>701	; kung lao hat proc #1
pid_orb1		.set	>702	; reptile orb
pid_ice1		.set	>703	; ice proc #1

*
* 800 = player 2 projectile procs
*
pid_proj2	.set	>800	; generic projectile !!
pid_hat2		.set	>801	; kung lao hat proc #2
pid_orb2		.set	>802	; reptile orb
pid_ice2		.set	>803	; ice proc #2


pid_volume	.set	>7000

*
* 8000 = coin switch pids
*
pid_lc		.set	>8c00		; left coin	
pid_cc		.set    >8c02		; center coin	
pid_rc		.set    >8c04		; right coin	
pid_xc		.set	>8c06		; fourth coin slot
pid_slam         .set    >8c08	 	; slam tilt process
pid_coinctr	.set	>8c0a		; coin counter process
pid_print	.set	>800c		; background printer process
pid_diag		.set	>800d		; diagnostics process
pid_secbust	.set	>800e		; sec bust proc

**************************************************************************
*											     *
*                       object id's							     *
*											     *
**************************************************************************
oid_blood	.set	pid_blood
oid_lightning	.set	pid_lightning
oid_p1		.set	pid_p1
oid_p2		.set	pid_p2
oid_fx		.set	pid_fx		; special f/x
oid_head		.set	pid_head
oid_grow		.set	pid_grow
oid_bones	.set	pid_bones
oid_1_puff	.set	pid_1_puff

* when adding more proc's for projectiles make sure you update
* wait_for_prj routine

*
* 700 = projectiles
*
oid_hat1		.set	>700	; hathead projectile
oid_fireball	.set	>701	; kang projectile
oid_snot		.set	>702	; cage projectile
oid_snot_trail1	.set	>703	;
oid_snot_trail2	.set	>704	;
oid_fans1	.set	>705	; player 1 fans
oid_fans2	.set	>706	; player 2 fans
oid_sai1		.set	>707
oid_sai2		.set	>708
oid_slow_proj	.set	>709	; slow reptile projectile
oid_hat2		.set	>70a	; hathead projectile


*
* 800 = non-game related
*
oid_cbox		.set	>800	; collision box
oid_text		.set	>801
oid_cursor1	.set	>802	; player 1 select cursor
oid_cursor2	.set	>803	; player 2 select cursor
oid_buyin	.set	>804	; buyin object
oid_symbol	.set	>805	; bonus count symbol

gs_amode		.set	001h	; game is in attract mode
gs_fighting	.set	002h
gs_buyin		.set	003h
gs_psel		.set	004h	; fighter select mode
gs_bonus		.set	005h	; bonus count state
gs_pfsetup	.set	006h	; pre-fight setup state
gs_round_intro	.set	007h	; round intro
gs_diag		.set	008h	; game is in diagnostics/audits/adjustments
gs_pitfall	.set	009h	; fallin down the pit
gs_initials	.set	00ah	; enter initials
gs_gameover	.set	00bh	; game over
gs_octopus	.set	00ch	; octopus mode
gs_post_psel	.set	00dh	; post player select mode
gs_barge		.set	00eh	; player barging in mode
gs_sec_intro	.set	00fh	; intro secret

; when adding entries, add to jump table

**************************************************************************
*											     *
*  mproc equates										     *
*											     *
**************************************************************************

	.global	prcslp
	.globl	kilall,getprc,kill,pinit,sucide,prcslp,prcdsp,prclsp,existp
	.globl	rand,timer,overload,active,free,prcstr
	.globl	sndres,sndresp,qsndrst

*
* process data structure
* note: make sure this is evenly divisible by 32
*
plink	.set	0		;link to next 32 bits
procid	.set	20h		;uhw process id 16 bits
ptime	.set	30h		;uhw sleep time x 16msec 16 bits
psptr	.set	40h		;uhl process stack pointer 32 bits
pa11	.set	60h		;uhl	registers saved
pa10	.set	80h		;uhl
pa9	.set	0a0h		;uhl
pa8	.set	0c0h		;uhl
pwake	.set	0e0h		;uhl
pdata	.set	100h		;process data store
psdata	.set	3d0h		;process stack data (pc, a8-a11)
;prcsiz	.set	5a0h		;end of data structure
prcsiz	.set	6f0h		;end of data structure
nproc	.set	168		;number of processes

;***************
;psdata	.set	2a0h		;process stack data (pc, a8-a11)
;psdata	.set	340h		;process stack data (pc, a8-a11)
;***************


**************************************************************************
*											     *
*   process storage equates								     *
*											     *
**************************************************************************
p_joyport	.set	pdata		; (32) - joystick switch port location
p_butport	.set	pdata+020h	; (32) - button port
p_otherguy	.set	pdata+040h	; (32) - other guys object
p_otheract	.set	pdata+060h	; (16) - drone info: other dudes last action
p_otherproc	.set	pdata+070h	; (32) - other guys process
p_slave		.set	pdata+090h	; (32) - slave object
p_anitab		.set	pdata+0b0h	; (32) - current animation table
p_anirate	.set	pdata+0d0h	; (16) - animation speed
p_anicount	.set	pdata+0e0h	; (16) - animation counter
p_action		.set	pdata+0f0h	; (16) - current action
p_ganiy		.set	pdata+100h	; (16) - grounded animation point y
p_flags		.set	pdata+110h	; (16) - more flags
p_downcount	.set	pdata+120h	; (16) - # ticks i have been ducking
p_store1		.set	pdata+130h	; (32) - long word storage #1
p_store2		.set	pdata+150h	; (32) - long word storage #2
p_store3		.set	pdata+170h	; (32) - long word storage #3
p_store4		.set	pdata+190h	; (32) - long word storage #4
p_store5		.set	pdata+1b0h	; (32) - long word storage #5
p_store6		.set	pdata+1d0h	; (32) - long word storage #6
p_store7		.set	pdata+1f0h	; (32) - long word storage #7
p_store8		.set	pdata+210h	; (32) - long word storage #8
p_dronevar1	.set	pdata+230h	; (32) - drone variable #1
p_stk		.set	pdata+250h	; (16) - strike table I am using (ejbpatch-use only 1 word)
p_hitby		.set	pdata+260h	; (16) - i was "hit by" this last
p_hit		.set	pdata+270h	; (8)  - hit count
p_end		.set	pdata+280h+8	; end of p info

**************************************************************************
*											     *
*  drone variables (local)								     *
* 											     *
*  warning: when adding local equates make sure they are not referenced  *
*           by their global name anywhere in this module !!!		     *
*											     *
**************************************************************************
p_beware_return	.set	p_joyport	; drone_beware return address
p_beware_a10	.set	p_butport	; a10 when drone_beware was called
p_beware_a11	.set	p_store6	; a11 when drone_beware was called

p_dcount		.set	p_store4+16		; local: generic drone counter
p_acc		.set	p_store5		; local: acceleration value
p_dsave1		.set	p_store7		; local: generic save #1
p_maxproj	.set	p_dronevar1		; local: # of projectiles allowed
p_egoro		.set	p_downcount		; local: # of times emp was goro

**************************************************************************
*											     *
*  palette allocator equates								     *
* 											     *
*  palette allocation ram								     *
*  for each color palette id 32 bits, palette count 16 bits		     *
*  if palcnt>0 palette is allocated, if palcnt=0 palette is free	     *
*											     *
**************************************************************************
numpal	.set	60	;number of dynamics allocated palettes
nmfpal	.set	25	;number of foreground palettes
nmbpal	.set	35	;number of background palettes

palid	.set	0	; palette i.d.
palcnt	.set	020h	; palette allocation count
paltime	.set	030h	; @tick value when this palette was deleted
palrsiz	.set	040h	; size of palette allocation ram


*
* palette transfer ram
*
pldcnt	.set	0	;color count
palsrc	.set	010h	;source address of palette color data 	
paldest	.set	030h	;destination palette|start color
ptrsiz	.set	040h	;size of each cell
numptr	.set	24	;number of transfers allowed

**************************************************************************
*											     *
*  ascii font miscellaneous equates							     *
*											     *
**************************************************************************
f15sp	equ	7eh		;font 15 sp character, for hs entry
f15rub	equ	f15sp+1		;font 15 rub character,for hs entry
f15end	equ	f15rub+1	;font 15 end character,for hs entry
f15rquot equ	f15end+1	;font 15 right quote


