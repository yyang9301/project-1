;***************************************************************************
;Draw the regression pattern based on the first three eof_ts 
;   1.horizontal distribution of 200hPa level
;   2.horizontal distribution of vertical average 
;   3.vertical section of zonal mean 
;   4.latitude distribution of vertical average and zonal mean
;   5.vertical section of meridional mean 
;   6.longtitude distribution of vertical average and meridional mean
;                                            by Ql_Ren
;                                           2020/02/25
;******************************************************************************
begin
var_option = 1  ;0 means Qd; 1 means f_Qd; 2 means dzdt; 3 means duTdx; 4 means dzdt induced by b1
do var_option = 1,4,3
if(var_option.eq.-4) then 
    draw_var := (/"b1","b2","b3"/)  ;this is the variable used to draw, can used as center string
    var_name := (/"b1","b2","b3"/)  ;this is the variable used to draw, can used as center string
    unit     := "10~S~-11~N~" + (/"s~S~-2~N~","s~S~-2~N~","s~S~-2~N~"/)  ;this can be used as right string 
end if
if(var_option.eq.-3) then 
    draw_var := (/"Qeddh","Ah"/)  ;this is the variable used to draw, can used as center string
    var_name := (/"Qeddh","Ah"/)  ;use to read variables
    unit     := (/"K/Day","10~S~-11~N~s~S~-2~N~"/)  ;this can be used as right string 
end if
if(var_option.eq.-2) then 
    draw_var := (/"Qeddl","Al"/)  ;this is the variable used to draw, can used as center string
    var_name := (/"Qeddl","Al"/)  ;use to read variables
    unit     := (/"K/Day","10~S~-11~N~s~S~-2~N~"/)  ;this can be used as right string 
end if
if(var_option.eq.-1) then 
    draw_var := (/"Qd"   ,"Qeddy","A"/)  ;this is the variable used to draw, can used as center string
    var_name := (/"Qd"   ,"Qeddy","A"/)  ;use to read variables
    unit     := (/"K/Day","K/Day","10~S~-11~N~s~S~-2~N~"/)  ;this can be used as right string 
end if
if(var_option.eq.0) then 
    draw_var := (/"Qd"   ,"Qeddy","total"/)  ;this is the variable used to draw, can used as center string
    var_name := (/"Qd"   ,"Qeddy"/)  ;use to read variables
    unit     := (/"K/Day","K/Day","K/day"/)  ;this can be used as right string 
end if
if(var_option.ge.1) then
var_name := (/"dzdt","dudt" ,"dTdt","dbdt"/)  ;
unit     := (/"10~S~-3~N~m~S~2~N~/s~S~3~N~","10~S~-7~N~m/s~S~2~N~","10~S~-6~N~K/s","10~S~-12~N~K/(m*s)"/)  ;this can be used as right string 
nnv = 1 ;used to read dzdt induced by different forcing
if(var_option.eq.1) then 
    draw_var := (/"Qd"  ,"Qeddy","A"/)  ;this is the variable used to draw, can used as center string
    select := (/0,1,2/) ;(/1,2,3/) ;0 is Qd, 1 is Qd_t
end if
if(var_option.eq.2) then 
    draw_var := (/"Qeddl","Al"/)  ;this is the variable used to draw, can used as center string
    select := (/1,3/) ;(/1,2,3/) ;0 is Qd, 1 is Qd_t
end if
if(var_option.eq.3) then 
    draw_var := (/"Qeddh","Ah"/)  ;this is the variable used to draw, can used as center string
    select := (/0,2/) ;(/1,2,3/) ;0 is Qd, 1 is Qd_t
end if
if(var_option.eq.4) then 
    draw_var := (/"b1","b2","b3"/)  ;this is the variable used to draw, can used as center string
    select := (/0,1,2/) ;(/1,2,3/) ;0 is Qd, 1 is Qd_t
end if
end if
nvar = dimsizes(draw_var)

area = (/"ME","EA","NA"/);,"GB"
lats = (/ 10 , 10 , 10 /);, 10  ;-90 ,-90 ,-90 ,-90 
latn = (/ 60 , 60 , 60 /);, 60  ;90 , 90 , 90 , 90 
lonl = (/ 20 ,105 , 250/);, 0   ;30 ;20
lonr = (/ 60 ,175 , 320/);, 360 ;150;220
lon_spacing = 20
lat_spacing = 10
narea = dimsizes(area)
neval = 4
siglvl = 0.05
years = ispan(1979,2015,1)

case   = "ERA-Interim"
path   = "/home/ys17-19/renql/project/2020MiddleEastJet/"
filename0  = path + "data/eof_u_6kinds-" + area + ".nc"
if(var_option.eq.-5)
    filename = path + "data/" + case + "_DJF_" + draw_var(nv) + "-year.nc"
    fig_name   = path + "fig/eof_regression_ver-" + draw_var(nv)
end if
if(var_option.eq.-4)
    filename = path + "data/" + case + "_DJF_forc_in-year.nc"
    fig_name = path + "fig/eof_regression_ver-" + var_name(0)
end if
if(var_option.le.-2.and.var_option.ge.-3)
    filename = path + "data/" + case + "_DJF_forc_te-year.nc"
    fig_name = path + "fig/eof_regression_ver-" + var_name(0)
end if
if(var_option.le.0.and.var_option.ge.-1)
    filename = path + "data/" + case + "_DJF_forc_ex-year.nc"
    fig_name = path + "fig/eof_regression_ver-" + var_name(0)
end if
if(var_option.eq.1)
    filename = path + "data/" + case + "_DJF_dzdt_ex-year.nc"
    fig_name = path + "fig/eof_regression_ver-" + var_name(nnv) + "_" + draw_var(0)
end if
if(var_option.ge.2.and.var_option.le.3)
    filename = path + "data/" + case + "_DJF_dzdt_te-year.nc"
    fig_name = path + "fig/eof_regression_ver-" + var_name(nnv) + "_" + draw_var(0)
end if
if(var_option.eq.4)
    filename = path + "data/" + case + "_DJF_dzdt_in-year.nc"
    fig_name = path + "fig/eof_regression_ver-" + var_name(nnv) + "_" + draw_var(0)
end if
fig_out    = "pdf" ;"eps";"x11"
pre_case   = (/"(a","(b","(c", "(d","(e","(f", "(g","(h","(i", "(j","(k","(l", "(m","(n","(o", "(p","(q","(r"/)
plot   = new((/18/),graphic)
line   = new((/18/),graphic)
regl   = new((/18/),graphic)
sigl   = new((/18/),graphic)

;===============================================
;draw the figure
;=============================================
;define the thickness and height of the title,tick and label
   tick_font      = 0.03
   subtitle_font  = 0.03
   title_font     = 0.03
   label_font     = 0.015
   tick_thick     = 5.0
   subtitle_thick = 5.0  ;not have this attribute
   title_thick    = 5.0
   label_thick    = 1.5
   mp_thick       = 3.0
   font_index     = 22

    wks = gsn_open_wks(fig_out,fig_name)
    gsn_define_colormap(wks,"BlueDarkRed18")
    ;blue and red, has 18 colors,2-10 is blue

    res                  = True
    res@gsnFrame         = False
    res@gsnDraw          = False
    res@gsnMaximize      = True
    res@gsnAddCyclic     = False
    res@vpWidthF  = 0.8
    res@vpHeightF = 0.6
    res@gsnCenterString      = ""
    res@gsnStringFont        = font_index
    res@gsnStringFontHeightF = subtitle_font

;--------set the form of the coordinate-----------------
    res@tmBorderThicknessF  = mp_thick
    res@tmXBLabelFont   = font_index
    res@tmYLLabelFont   = font_index
    res@tmXBLabelFontHeightF     = tick_font
    res@tmXBLabelFontThicknessF  = tick_thick
    res@tmYLLabelFontHeightF     = tick_font
    res@tmYLLabelFontThicknessF  = tick_thick
    res@tmXBMajorThicknessF     = mp_thick
    res@tmYLMajorThicknessF     = mp_thick
    res@tmXBMinorThicknessF     = mp_thick
    res@tmYLMinorThicknessF     = mp_thick
    res@gsnPresHgtHeightLabelOn = False
    res@tiYAxisOn = False
    res@tmYRLabelsOn = False
    res@tmXBMode = "Manual"
    res@tmXBTickSpacingF   = lat_spacing 

;---------set the attribute of the contour-----------------
    res@cnFillOn         = True
    res@cnLinesOn        = False
    res@cnLineLabelsOn   = False
    res@cnInfoLabelOn    = False

    res@lbLabelBarOn         = False   ; the label bar
    res@lbOrientation        = "Horizontal"
    res@lbLabelFontHeightF   = tick_font              ; make labels smaller
    res@lbLabelFont          = font_index              ; make labels smaller
    res@lbLabelStride        = 1
    res@lbBoxLineThicknessF  = mp_thick-1
    res@pmLabelBarZone               = 0
    res@pmLabelBarOrthogonalPosF     = 0.2
    res@pmLabelBarParallelPosF       = 0.5
    ;res@pmLabelBarWidthF  = 0.7
    ;res@pmLabelBarHeightF = 0.1

;---------set the attribute of the contour-----------------
    res_line = True
    res_line@gsnDraw          = False
    res_line@gsnFrame         = False
    res_line@gsnAddCyclic     = False
    res_line@cnFillOn         = False
    res_line@cnLinesOn        = True
    res_line@cnLineLabelsOn   = True ;False
    res_line@cnLineLabelFontHeightF = 0.015
    res_line@cnInfoLabelOn    = False
    res_line@cnLineThicknessF = 4.0
    res_line@cnLineColor      = "blueviolet";"green4";"black"
    res_line@gsnContourZeroLineThicknessF = 8
    levels = new((/10/),integer)
    levels(0) = 0
    levels(1:9) = ispan(5,85,10)
    res_line@cnLevelSelectionMode = "ExplicitLevels"    ;set manual contour levels
    res_line@cnLevels             = levels       ; set contour interval
    res_line@lbLabelBarOn     = False   ; the label bar
    res_line@gsnCenterString  = ""
    res_line@gsnLeftString    = " "
    res_line@gsnRightString   = " "
    res_line@gsnPresHgtHeightLabelOn = False
    res_line@tiYAxisOn = False

    reg_line = res_line
    reg_line@cnLineThicknessF = 3.5
    reg_line@cnLineColor      = "black"
    reg_line@gsnContourZeroLineThicknessF = 0
    reg_line@gsnContourNegLineDashPattern = 2
    reg_line@gsnContourPosLineDashPattern = 0
    reg_line@cnLevelSelectionMode = "AutomaticLevels"   ; set manual contour levels
    reg_line@cnLevelSpacingF       = 0.5     ; set contour interval

;----------Set res sig-----------
    res_sig                  = True       ; use plot options
    res_sig@cnFillOn         = True       ; Fill contours
    res_sig@cnLinesOn        = False;True      ; turn off contour lines
    res_sig@gsnFrame         = False
    res_sig@gsnDraw          = False
    res_sig@cnLineLabelsOn   = False      ; turn off contour line labels
    res_sig@cnLineThicknessF = 2
    ;res_sig@cnLineColor     = "black"
    res_sig@cnInfoLabelOn    = False
    res_sig@cnMonoFillPattern= True;False
    res_sig@cnFillPattern    = 11
    res_sig@cnMonoFillScale  = True
    res_sig@cnFillScaleF     = 0.5
    res_sig@cnMonoFillColor  = True
    res_sig@cnFillColor      = "darkslategray"
    res_sig@cnFillDotSizeF   = 0.1
    res_sig@lbLabelBarOn     = False;True   ; turn off the label bar
    ;res_sig@cnLevelSelectionMode ="ExplicitLevels"
    ;res_sig@cnLevels             = (/3000,1000/)
    res_sig@gsnLeftString    = " "
    res_sig@gsnRightString   = " "
    res_sig@gsnPresHgtHeightLabelOn = False
    res_sig@tiYAxisOn = False

    resp  = True    
    resp@gsnMaximize   = True
    resp@gsnPaperOrientation = "landscape";"portrait" ;
    resp@gsnPanelLabelBar = True
    resp@lbOrientation    = "Vertical" ;"Horizontal"
    resp@pmLabelBarWidthF  = 0.06
    resp@pmLabelBarHeightF = 0.8
    resp@lbLabelFont        = font_index              ; make labels smaller
    resp@lbLabelFontHeightF = 0.015 
    resp@lbLabelFontThicknessF = tick_thick
    resp@txFontHeightF = title_font 
    resp@txFontThicknessF = title_thick

if(var_option.eq.-5) then
if(nv.eq.0) then
    minlvl = (/-7 /)
    maxlvl = (/ 7 /)
    spacig = (/ 1 /)
end if
end if
    
if(var_option.eq.-4) then
    minlvl = (/-14,-14,-14/);-8,-8,-8,-8,
    maxlvl = (/ 14, 14, 14/); 8, 8, 8, 8,
    spacig = (/ 2 , 2 , 2 /); 1, 1, 1, 1,
end if
    
if(var_option.lt.-1.and.var_option.ge.-3) then
    minlvl = (/-2.1,-14/);-8,-8,-8,-8,
    maxlvl = (/ 2.1, 14/); 8, 8, 8, 8,
    spacig = (/ 0.3, 2 /); 1, 1, 1, 1,
end if
    
if(var_option.eq.-1) then
    minlvl = (/-2.1,-2.1,-14/);-8,-8,-8,-8,
    maxlvl = (/ 2.1, 2.1, 14/); 8, 8, 8, 8,
    spacig = (/ 0.3, 0.3, 2 /); 1, 1, 1, 1,
end if
    
if(var_option.eq.0) then 
    minlvl = (/-2.1,-2.1,-2.1/);
    maxlvl = (/ 2.1, 2.1, 2.1/);
    spacig = (/ 0.3, 0.3, 0.3/);
end if

if(var_option.ge.1) then
if(nnv.eq.0) then   ;dzdt
    minlvl = (/-3.5,-3.5,-3.5,-3.5/);
    maxlvl = (/ 3.5, 3.5, 3.5, 3.5/);
    spacig = (/ 0.5, 0.5, 0.5, 0.5/);
end if
if(nnv.eq.1) then ;dudt
    minlvl = (/-35,-35,-35,-35/);-8,-8,-8,-8,
    maxlvl = (/ 35, 35, 35, 35/); 8, 8, 8, 8,
    spacig = (/ 5 , 5 , 5 , 5 /); 1, 1, 1, 1,
end if
if(nnv.eq.2) then ;dTdt
    minlvl = (/-16,-16,-16,-16/);
    maxlvl = (/ 16, 16, 16, 16/);
    spacig = (/  2,  2,  2,  2/);
end if
if(nnv.eq.3) then ;dbdt
    minlvl = (/-24,-24,-24,-24/);
    maxlvl = (/ 24, 24, 24, 24/);
    spacig = (/  3,  3,  3,  3/);
end if
end if

lev  = (/1000,950,900,850,800, 750,700,650,600,550, 500,450,400,350,300, 250,200,175,150,125, 100/)
nlev = dimsizes(lev)
sig   = new((/narea,6,neval/),logical)
eval  = new((/narea,6,neval/),float)
pcvar = new((/narea,6,neval/),float)
f  = addfile(filename0(0),"r")
ts := f->eof_ts
nyear = dimsizes(ts&year)
ts := new((/narea,6,neval,nyear/),float)

do na = 0, narea-1,1
f  = addfile(filename0(na),"r")
ts(na,:,:,:) = f->eof_ts
eof0 := f->eof0
eof1 := f->eof1
eof2 := f->eof2
eof3 := f->eof3
eof4 := f->eof4
eof5 := f->eof5
sig(na,0,:)  = eofunc_north(eof0@pcvar,nyear,False)
sig(na,1,:)  = eofunc_north(eof1@pcvar,nyear,False)
sig(na,2,:)  = eofunc_north(eof2@pcvar,nyear,False)
sig(na,3,:)  = eofunc_north(eof3@pcvar,nyear,False)
sig(na,4,:)  = eofunc_north(eof4@pcvar,nyear,False)
sig(na,5,:)  = eofunc_north(eof5@pcvar,nyear,False)
eval(na,0,:) = eof0@eval
eval(na,1,:) = eof1@eval
eval(na,2,:) = eof2@eval
eval(na,3,:) = eof3@eval
eval(na,4,:) = eof4@eval
eval(na,5,:) = eof5@eval
pcvar(na,0,:) = eof0@pcvar
pcvar(na,1,:) = eof1@pcvar
pcvar(na,2,:) = eof2@pcvar
pcvar(na,3,:) = eof3@pcvar
pcvar(na,4,:) = eof4@pcvar
pcvar(na,5,:) = eof5@pcvar
end do
;ts = dim_standardize_n(ts,1,3)
ts = ts/conform(ts,sqrt(eval),(/0,1,2/))
subtitle_color = where(sig,"red","black") 

na = 0
f2 = addfile(path + "/data/ERA-Interim_DJF_uwnd-year.nc","r")
u := f2->season_ave(0,:,{lats(na):latn(na)},{lonl(na):lonr(na)})
nlat = dimsizes(u&lat)
nlev_u = dimsizes(u&lev)
vars := new((/narea,nvar,nyear,nlev,nlat/),double)
u    := new((/narea,nyear,nlev_u,nlat/),double)

f3 = addfile(filename,"r")
do na = 0, narea-1,1
u(na,:,:,:) = dim_avg_n_Wrap(f2->season_ave(:,:,{lats(na):latn(na)},{lonl(na):lonr(na)}),3)
if(var_option.le.0.and.var_option.ge.-4)
    do nv = 0, nvar-1,1
    vars(na,nv,:,:,:) = dim_avg_n_Wrap(f3->$var_name(nv)$(:,{lev},{lats(na):latn(na)},{lonl(na):lonr(na)}),3)
    end do
else
    vars(na,:,:,:,:)  = dim_avg_n_Wrap(f3->$var_name(nnv)$(select,:,{lev},{lats(na):latn(na)},{lonl(na):lonr(na)}),4)
end if
end do

;remove_mean = True
;return_info = True
;var1 := dtrend_msg_n(years,vars,remove_mean,return_info,2)
;print("max slope is " + max(var1@slope))
;print("min slope is " + min(var1@slope))
;print("max intercept is " + max(var1@y_intercept))
;print("min intercept is " + min(var1@y_intercept))

var  := regCoef_n(ts,vars,3,2)
ureg := regCoef_n(ts,u   ,3,1)
tval := onedtond(var@tval ,(/narea,6,neval,narea,nvar,nlev,nlat/))
df   := onedtond(var@nptxy,(/narea,6,neval,narea,nvar,nlev,nlat/))
utval := onedtond(ureg@tval ,(/narea,6,neval,narea,nlev_u,nlat/))
udf   := onedtond(ureg@nptxy,(/narea,6,neval,narea,nlev_u,nlat/))
u    := dim_avg_n_Wrap(u   ,1)
copy_VarCoords(vars(0,0,0,:,:), var(0,0,0,0,0,:,:))
copy_VarCoords(u(0,:,:), ureg(0,0,0,0,:,:))
printVarSummary(var)

b := tval 
b = 0.5
prob  := betainc( df/(df+tval^2), df/2.0, b )
prob  = mask(prob,prob.lt.siglvl,True)
copy_VarCoords(vars(0,0,0,:,:), prob(0,0,0,0,0,:,:))
b := utval 
b = 0.5
uprob  := betainc( udf/(udf+utval^2), udf/2.0, b )
;ureg   = mask(ureg,uprob.lt.siglvl,True)
print(max(tval))
print(min(tval))
print(max(df))
print(min(df))

if(var_option.eq.-4) then 
    var = var*10^11
end if

if(var_option.lt.-1.and.var_option.ge.-3) then 
    var(:,:,:,:,1,:,:) = var(:,:,:,:,1,:,:)*10^11
    var(:,:,:,:,0,:,:) = var(:,:,:,:,0,:,:)*24*3600
end if

if(var_option.eq.-1) then 
    var(:,:,:,:,2,:,:) = var(:,:,:,:,2,:,:)*10^11
    var(:,:,:,:,0:1,:,:) = var(:,:,:,:,0:1,:,:)*24*3600
end if

if(var_option.eq.0) then 
    var = var*24*3600 ;convert units of Q from K/s to K/Day 
end if

if(var_option.ge.1) then
if(nnv.eq.0) then
    var = var*10^3
end if
if(nnv.eq.1) then
    var = var*10^7
end if
if(nnv.eq.2) then
    var = var*10^6
end if
if(nnv.eq.3) then
    var = var*10^12
end if
end if

res@cnFillColors  = (/2,3,4,5,6,7,8,9,12,13,14,15,16,17,18,19/)
do nk = 0, 0, 1
do ne = 0, 2, 1 ;neval-2, 1
do na = 0, narea-1,1
do nv = 0, nvar-1,1
    nev = ne + 1
    np  = na*nvar + nv ;1 var ;2 area
    ;np = nk*(neval-1) + ne ;1 eof ;2 kind; 3 area
    res@tmXBTickStartF     = lats(na)
    res@tmXBTickEndF       = latn(na)
    res@gsnLeftString   = pre_case(np) + ") " + area(na) + " " + lonl(na) + "-" + lonr(na) + "E"
    res@gsnRightStringFontColor   = subtitle_color(na,nk,ne)
    if(var_option.ge.1) then 
    res@gsnRightString  = draw_var(nv) + " (" + unit(nnv) + ") "; + eval(na,nk,ne) + "  " + pcvar(na,nk,ne)+"%" 
    else
    res@gsnRightString  = draw_var(nv) + " (" + unit(nv) + ")"
    end if
    if(nv.gt.10) then
    res@cnLevelSelectionMode  = "AutomaticLevels" ; set manual contour levels
    else
    res@cnLevelSelectionMode  = "ManualLevels" ; set manual contour levels
    res@cnLevelSpacingF       := spacig(nv)        ; set contour interval
    res@cnMaxLevelValF        := maxlvl(nv) ;32    ; set max contour level
    res@cnMinLevelValF        := minlvl(nv)       ; set min contour level
    end if
    plot(np) = gsn_csm_pres_hgt(wks, var(na,nk,ne,na,nv,:,:),res)
    sigl(np) = gsn_csm_pres_hgt(wks,prob(na,nk,ne,na,nv,:,:),res_sig)
    overlay(plot(np),sigl(np))
    regl(np) = gsn_csm_pres_hgt(wks,ureg(na,nk,ne,na,:,:),reg_line)
    overlay(plot(np),regl(np))
    line(np) = gsn_csm_pres_hgt(wks,u(na,:,:),res_line)
    overlay(plot(np),line(np))
    print(max(var(na,nk,ne,na,nv,:,:)))
    print(min(var(na,nk,ne,na,nv,:,:)))
end do 
end do 
;    resp@txString = area(na) + " (" + lats(na) + "-" + latn(na) + "N," + lonl(na) + "-" + lonr(na) + "E)"
    resp@txString = var_name(nnv) + " " + nk + " EOF" + nev ;+ " " + eval(na,nk,ne) + "  " + pcvar(na,nk,ne)+"%" 
    gsn_panel(wks,plot,(/narea,nvar/),resp)
end do ;area 
end do ;area 
end do ;area 
end

