drop program ahs_cust_mpage_boilerplate go
create program ahs_cust_mpage_boilerplate
PROMPT
  "Output to File/Printer/MINE" = "MINE" ,
  "Person Id:" = 0.00
  WITH outdev, personid

/*******************************************************************************
PROGRAM INFO
********************************************************************************

***********************************************************************************
Revisions
Date Revision 		#			Person 			Person Note
23/01/2025			001			PALMCX			Created
***********************************************************************************/


free record demographics
record demographics (
   1 pat_name
     2 pat_name = vc
     2 updt_dt_tm = vc
   1 pat_sex
     2 pat_sex = vc
     2 updt_dt_tm = vc
   1 pat_dob
     2 pat_dob = vc
     2 updt_dt_tm = vc
   1 pat_age
     2 pat_age = vc
     2 updt_dt_tm = vc
   1 pat_marital_status
     2 pat_marital_status = vc
     2 updt_dt_tm = vc
   1 pat_pbs_elgb_status
     2 pat_pbs_elgb_status = vc
     2 updt_dt_tm = vc
   1 pat_cob
     2 pat_cob = vc
     2 updt_dt_tm = vc
   1 pat_primary_lang
     2 pat_primary_lang = vc
     2 updt_dt_tm = vc
   1 pat_interp_rqd
     2 pat_interp_rqd = vc
     2 updt_dt_tm = vc
   1 pat_religion
     2 pat_religion = vc
     2 updt_dt_tm = vc
   1 pat_indigenous_status
     2 pat_indigenous_status = vc
     2 updt_dt_tm = vc
   1 pat_deceased
     2 pat_deceased = vc
     2 updt_dt_tm = vc
   1 pat_deceased_dt_tm
     2 pat_deceased_dt_tm = vc
     2 updt_dt_tm = vc
   1 pat_addresses [* ]
     2 addr = vc
     2 addr_type = vc
     2 updt_dt_tm = vc
   1 pat_names [* ]
     2 name = vc
     2 name_type = vc
     2 updt_dt_tm = vc
   1 pat_contact_info [* ]
     2 ph_number = vc
     2 ph_type = vc
     2 updt_dt_tm = vc
   1 pat_aliases [* ]
     2 alias = vc
     2 alias_type = vc
     2 alias_pool = vc
     2 updt_dt_tm = vc
   1 pat_hp [1 ]
     2 type = vc
     2 plan_name = vc
     2 insur_name = vc
     2 insur_ph = vc
     2 group_name = vc
     2 policy_nbr = vc
     2 member_nbr = vc
     2 deduct_amt = vc
     2 address = vc
     2 updt_dt_tm = vc
 )


/**************************************************************
; DVDev DECLARED VARIABLES
**************************************************************/
DECLARE cob_cd = f8 WITH constant (uar_get_code_by ("DISPLAYKEY" ,212 ,"BIRTH" ) ) ,protect
DECLARE addressStr = vc


/**************************************************************
; DVDev Start Coding
**************************************************************/


select into "NL:"
  p.person_id
  from person p
  plan (p
  	where (p.active_ind = 1 )
   	and (p.person_id =  $PERSONID ) )
  head p.person_id
   demographics->pat_age.pat_age = concat (trim (cnvtstring (datetimediff (cnvtdatetime (sysdate ) ,
       cnvtdatetime (p.abs_birth_dt_tm ) ,10 ) ) ) ," years" ) ,updt_dt_tm = days_ago (p.updt_dt_tm
    ) ,demographics->pat_age.updt_dt_tm = updt_dt_tm ,demographics->pat_name.pat_name = trim (p
    .name_full_formatted ) ,demographics->pat_name.updt_dt_tm = updt_dt_tm ,demographics->pat_sex.
   pat_sex = uar_get_code_display (p.sex_cd ) ,demographics->pat_sex.updt_dt_tm = updt_dt_tm ,
   demographics->pat_dob.pat_dob = format (p.abs_birth_dt_tm ,"DD/MM/YYYY HH:MM:SS" ) ,demographics->
   pat_dob.updt_dt_tm = updt_dt_tm ,demographics->pat_marital_status.pat_marital_status =
   uar_get_code_display (p.marital_type_cd ) ,demographics->pat_marital_status.updt_dt_tm =
   updt_dt_tm ,demographics->pat_pbs_elgb_status.pat_pbs_elgb_status = uar_get_code_display (p
    .citizenship_cd ) ,demographics->pat_pbs_elgb_status.updt_dt_tm = updt_dt_tm ,demographics->
   pat_primary_lang.pat_primary_lang = uar_get_code_display (p.language_cd ) ,demographics->
   pat_primary_lang.updt_dt_tm = updt_dt_tm ,demographics->pat_indigenous_status.
   pat_indigenous_status = uar_get_code_display (p.race_cd ) ,demographics->pat_indigenous_status.
   updt_dt_tm = updt_dt_tm ,demographics->pat_religion.pat_religion = uar_get_code_display (p
    .religion_cd ) ,demographics->pat_religion.updt_dt_tm = updt_dt_tm ,demographics->pat_interp_rqd.
   pat_interp_rqd = uar_get_code_display (p.ethnic_grp_cd ) ,demographics->pat_interp_rqd.updt_dt_tm
   = updt_dt_tm ,
   if ((p.deceased_cd > 0.00 ) ) demographics->pat_deceased.pat_deceased = uar_get_code_display (p
     .deceased_cd ) ,demographics->pat_deceased.updt_dt_tm = updt_dt_tm ,demographics->
    pat_deceased_dt_tm.pat_deceased_dt_tm = format (p.deceased_dt_tm ,"DD/MM/YY HH:MM:SS" ) ,
    demographics->pat_deceased.updt_dt_tm = updt_dt_tm
   endif
  with nocounter
 ;end select


 select into "NL:"
  from (address a )
  where (a.parent_entity_name = "PERSON" )
  and (a.parent_entity_id =  $PERSONID )
  and (a.active_ind = 1 )
  head report
   addr_cnt = 0
  detail
   if ((a.address_type_cd = cob_cd ) ) demographics->pat_cob.pat_cob = uar_get_code_display (a
     .country_cd ) ,demographics->pat_cob.updt_dt_tm = days_ago (a.updt_dt_tm )
   else addr_cnt +=1 ,


    if ((mod (addr_cnt ,10 ) = 1 ) )
     call alterlist (demographics->pat_addresses ,(addr_cnt + 9 ) )
    endif
    		;001
    		if (a.street_addr != ' ' and textlen(a.street_addr) > 0)
		    	addressStr = build2(trim(a.street_addr), "<br>")
		    endif
		    if (a.street_addr2 != ' ' and textlen(a.street_addr2) > 0)
		    	addressStr = build2(addressStr, trim(a.street_addr2), "<br>")
		    endif
		    if (a.street_addr3 != ' ' and textlen(a.street_addr3) > 0)
		    	addressStr = build2(addressStr, trim(a.street_addr3), "<br>")
		    endif
		    if (a.street_addr4 != ' ' and textlen(a.street_addr4) > 0)
		    	addressStr = build2(addressStr, trim(a.street_addr4), "<br>")
		    endif
    ,demographics->pat_addresses[addr_cnt ].addr = build2 (addressStr ,trim (a
      .city ) ," " ,trim (a.state ) ," " ,trim (a.zipcode ) ) ,demographics->pat_addresses[addr_cnt ]
    .addr_type = uar_get_code_display (a.address_type_cd ) ,demographics->pat_addresses[addr_cnt ].
    updt_dt_tm = days_ago (a.updt_dt_tm )
   endif
  foot report
   call alterlist (demographics->pat_addresses ,addr_cnt )
  with nocounter
 ;end select




 select into "NL:"
  from (phone ph )
  where (ph.parent_entity_id =  $PERSONID )
  and (ph.parent_entity_name = "PERSON" )
  and (ph.active_ind = 1 )
  head report
   ph_cnt = 0
  detail
   ph_cnt +=1 ,
   if ((mod (ph_cnt ,10 ) = 1 ) )
    call alterlist (demographics->pat_contact_info ,(ph_cnt + 9 ) )
   endif
   ,demographics->pat_contact_info[ph_cnt ].ph_number = ph.phone_num ,
   demographics->pat_contact_info[ph_cnt ].ph_type = uar_get_code_display (ph.phone_type_cd ) ,
   demographics->pat_contact_info[ph_cnt ].updt_dt_tm = days_ago (ph.updt_dt_tm )
  foot report
   call alterlist (demographics->pat_contact_info ,ph_cnt )
  with nocounter
 ;end select




 select into "NL:"
  from (person_alias pa )
  where (pa.active_ind = 1 )
  and (pa.person_id =  $PERSONID )
  head report
   alias_cnt = 0
  detail
   alias_cnt +=1 ,
   if ((mod (alias_cnt ,10 ) = 1 ) )
    call alterlist (demographics->pat_aliases ,(alias_cnt + 9 ) )
   endif
   ,demographics->pat_aliases[alias_cnt ].alias = pa.alias ,
   demographics->pat_aliases[alias_cnt ].alias_pool = uar_get_code_display (pa.alias_pool_cd ) ,
   demographics->pat_aliases[alias_cnt ].alias_type = uar_get_code_display (pa.person_alias_type_cd
    ) ,
   demographics->pat_aliases[alias_cnt ].updt_dt_tm = days_ago (pa.updt_dt_tm )
  foot report
   call alterlist (demographics->pat_aliases ,alias_cnt )
  with nocounter
 ;end select



 select into "NL:"
  from (person_name pn )
  where (pn.active_ind = 1 )
  and (pn.person_id =  $PERSONID )
  head report
   pn_cnt = 0
  detail
   pn_cnt +=1 ,
   if ((mod (pn_cnt ,10 ) = 1 ) )
    call alterlist (demographics->pat_names ,(pn_cnt + 9 ) )
   endif
   ,demographics->pat_names[pn_cnt ].name = pn.name_full ,
   demographics->pat_names[pn_cnt ].name_type = uar_get_code_display (pn.name_type_cd ) ,
   demographics->pat_names[pn_cnt ].updt_dt_tm = days_ago (pn.updt_dt_tm )
  foot report
   call alterlist (demographics->pat_names ,pn_cnt )
  with nocounter
 ;end select



 select into "NL:"
  from (encounter e ),
   (encntr_plan_reltn epr ),
   (left
   join organization o on (o.organization_id = epr.organization_id )
   and (o.active_ind = 1 ) ),
   (left
   join phone ph on (ph.parent_entity_id = o.organization_id )
   and (ph.parent_entity_name = "ORGANIZATION" )
   and (ph.active_ind = 1 ) ),
   (left
   join address a on (a.parent_entity_id = o.organization_id )
   and (a.parent_entity_name = "ORGANIZATION" )
   and (a.active_ind = 1 ) ),
   (health_plan hp )
  plan (e
   where (e.active_ind = 1 )
   and (e.person_id =  $PERSONID ) )
   join (epr
   where (epr.encntr_id = e.encntr_id )
   and (epr.active_ind = 1 ) )
   join (o )
   join (ph )
   join (a )
   join (hp
   where (hp.health_plan_id = epr.health_plan_id )
   and (hp.active_ind = 1 ) )
  order by e.encntr_id DESC
  head e.encntr_id
   demographics->pat_hp[1 ].type = uar_get_code_display (hp.plan_type_cd ) ,demographics->pat_hp[1 ].
   plan_name = hp.plan_name ,demographics->pat_hp[1 ].insur_name = o.org_name ,demographics->pat_hp[
   1 ].insur_ph = ph.phone_num ,demographics->pat_hp[1 ].group_name = epr.group_name ,demographics->
   pat_hp[1 ].policy_nbr = epr.policy_nbr ,demographics->pat_hp[1 ].member_nbr = epr.member_nbr ,
   demographics->pat_hp[1 ].deduct_amt = concat ("$" ,cnvtstring (epr.deduct_amt ) ) ,demographics->
   pat_hp[1 ].updt_dt_tm = days_ago (epr.updt_dt_tm ) ,demographics->pat_hp[1 ].address = concat (
    evaluate (trim (a.street_addr ) ,"" ,"" ,concat (a.street_addr ,"<br>" ) ) ,evaluate (trim (a
      .street_addr2 ) ,"" ,"" ,concat (a.street_addr2 ,"<br>" ) ) ,evaluate (trim (a.city ) ,"" ,"" ,
     concat (a.city ,"," ) ) ,evaluate (trim (a.state ) ,"" ,"" ,concat (a.state ," " ) ) ,evaluate (
     trim (a.zipcode ) ,"" ,"" ,concat (a.zipcode ,"<br>" ) ) ,a.country )
  with maxrec = 1


 set _memory_reply_string = cnvtrectojson (demographics )

 free record demographics




/**************************************************************
; DVDev DEFINED SUBROUTINES
**************************************************************/


 subroutine  (days_ago (date =dq8 ) =vc )
  set days = datetimediff (cnvtdatetime (curdate ,curtime ) ,date )
  set updt_date = concat ("Last Updated on" ," " ,format (cnvtdatetime (cnvtdate (date ) ,0 ) ,
    "DD-MM-YYYY;;D" ) )
  return (updt_date )
 end

end
go
