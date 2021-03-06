;*********************************************************************
;Draw monthly preci in every month(3*4) of one case, just simply view 
;the distribution of a variable.
;                                                     by Ql Ren
;                                                    2019/07/12
;*********************************************************************************
begin
var_option   = 10
nnv = 0 ;used to read dzdt induced by different forcing

month_option = True;False
uv_option    = False ;True ;
duvdt_option = False ;True ;
case_option  = 0 ;0 means NUDG experiment; 1 means noTP experiment
nl   = 4 ;(/925,850,700,500,200/)
diff = True;False ;whether draw the difference
na = 1 ;"TP","EA","NH"

;months   = (/"DJF"/)
months   = (/"JF","MA","MJ","JA"/)
nmonth = dimsizes(months)
lev = (/925,850,700,500,200/)
area = (/"TP","EA","NH"/)
lats = (/15  ,10  , 10 /);20 ;-20
latn = (/55  ,60  , 89 /) ;55 ;60
lonl = (/70  ,30  , 0  /) ;30 ;20
lonr = (/105 ,150 ,360 /) ;150;220
month_s = 1
month_e = 8

if(var_option.eq.-6) then 
    draw_var = (/"sigm1"/)  ;this is the variable used to draw, can used as center string
    var_name = (/"sigm1"/)  ;use to read variables
    unit     = (/"10~S~-5~N~J/(Pa^2*Kg)"/)  ;this can be used as right string end if
end if
if(var_option.eq.-1) then 
    draw_var = (/"fQd" ,"fQte","Fte","total"/)  ;this is the variable used to draw, can used as center string
    var_name = (/"f_Qd","f_Qeddy","A","total"/)  ;use to read variables
    unit     = "10~S~-10~N~" + (/"s~S~-2~N~","s~S~-2~N~","s~S~-2~N~","s~S~-2~N~"/)  ;this can be used as right string 
end if
if(var_option.eq.0) then 
    draw_var = (/"Qd"   ,"Qte","total"/)  ;this is the variable used to draw, can used as center string
    var_name = (/"Qd"   ,"Qte"/)  ;use to read variables
    unit     = (/"K/Day","K/Day","K/day"/)  ;this can be used as right string 
end if
if(var_option.eq.1) then 
    draw_var = (/"Qd" ,"Qte","Fte","total"/)  ;this is the variable used to draw, can used as center string
    var_name = (/"dzdt","dudt","dTdt","dbdt","dvdt"/)  ;
    unit     = (/"10~S~-3~N~m~S~2~N~/s~S~3~N~","10~S~-6~N~m/s~S~2~N~","10~S~-6~N~K/s","10~S~-12~N~K/(m*s)","10~S~-6~N~m/s~S~2~N~"/)  ;this can be used as right string 
    select = (/0,1,2/) ;(/1,2,3/) ;0 is Qd, 1 is Qd_t
end if
if(var_option.eq.2) then 
    draw_var = (/"b1" ,"b2","b3","total"/)  ;this is the variable used to draw, can used as center string
    var_name = (/"dzdt","dudt","dTdt","dbdt","dvdt"/)  ;
    unit     = (/"10~S~-3~N~m~S~2~N~/s~S~3~N~","10~S~-6~N~m/s~S~2~N~","10~S~-6~N~K/s","10~S~-12~N~K/(m*s)","10~S~-6~N~m/s~S~2~N~"/)  ;this can be used as right string 
    select = (/0,1,2/) ;(/1,2,3/) ;0 is Qd, 1 is Qd_t
end if
if(var_option.eq.3) then 
    draw_var = (/"vort_x" ,"vort_y","b3","total"/)  ;this is the variable used to draw, can used as center string
    var_name = (/"dzdt","dudt","dTdt","dbdt","dvdt"/)  ;
    unit     = (/"10~S~-3~N~m~S~2~N~/s~S~3~N~","10~S~-6~N~m/s~S~2~N~","10~S~-6~N~K/s","10~S~-12~N~K/(m*s)","10~S~-6~N~m/s~S~2~N~"/)  ;this can be used as right string 
    select = (/0,1,2/) ;(/1,2,3/) ;0 is Qd, 1 is Qd_t
end if
if(var_option.eq.10) then 
    draw_var = (/"norain","small","medium","large","storm"/)  ;this is the variable used to draw, can used as center string
    var_name = (/"month_ave"/)  ;
    unit     = (/" "/)  ;this can be used as right string 
    select = (/0,1,2,3,4/) ;(/1,2,3/) ;0 is Qd, 1 is Qd_t
end if

;the path of the file
path    = "/home/ys17-19/renql/project/TP_NUDG"
if(case_option.eq.0) then
    case1   = (/"CTRL","NUDG6h"/);,"NUDG24h"/)
    case2   = (/"CTRL","NG6h-CTRL"/);, "NG24h-CTRL"/)
    gtopfile = path + "/analysis/mdata/" + "gtopo30_0.9x1.25.nc"
    nsample = 27
else
    case1   = (/"TP_CTRL","TP_CR"/)
    case2   = (/"CTRL"   ,"noTP"/)
    ;gtopfile = "/home/ys17-19/renql/model/TP_CR/USGS-gtopo30_1.9x2.5_noTP_c050602C.nc" 
    gtopfile = "/home/ys17-19/renql/model/TP_CTRL/USGS-gtopo30_1.9x2.5_remap_c050602.nc" 
    nsample = 10
end if

if((var_option.le.0))
    if(month_option) then
    if(nmonth.eq.1) then 
    filename = path + "/z_tendency-20191022/mdata/" + case1 + "-Clim_DJF_Qd_Qeddy_A.nc"
    else
    filename = path + "/z_tendency-20191022/mdata/" + case1 + "-Clim_month_Qd_Qeddy_A.nc"
    end if
    else
    filename = path + "/z_tendency-20191022/mdata/" + case1 + "-Clim_daily_Qd_Qeddy_A.nc"
    end if
    fig_name = path + "/z_tendency-20191022/fig/1p2x3_clim_" + var_name(0) + "-" + lev(nl)  
else
    if(month_option) then
    if(nmonth.eq.1) then 
        filename = path + "/z_tendency-20191022/mdata/" + case1 + "-Clim_dzdt_DJF.nc"
    else
        if(var_option.eq.1) then 
        filename = path + "/z_tendency-20191022/mdata/" + case1 + "-Clim_dzdt_month_lon.nc"
        end if
        if(var_option.eq.2) then 
        filename = path + "/z_tendency-20191022/mdata/" + case1 + "-Clim_dzdt_advect_month.nc"
        end if
        if(var_option.eq.3) then 
        filename = path + "/z_tendency-20191022/mdata/" + case1 + "-Clim_dzdt_advect2_month.nc"
        end if
        if(var_option.eq.10) then 
        filename = path + "/analysis/mdata/" + case1 + "-rainfall_frequency.nc"
        end if
    end if
    else
    filename = path + "/z_tendency-20191022/mdata/" + case1 + "-Clim_daily_dzdt.nc"
    end if
    fig_name = path + "/z_tendency-20191022/fig/1p2x3_clim_" + draw_var(0) + "_" + var_name(nnv) + "-" + lev(nl)  
end if
;fig_title  = "Seasonal " + draw_var(nv) + " variance in " ;+season
pre_case   = (/"(a","(b","(c","(d","(e","(f","(g","(h","(i","(j","(k","(l","(m","(n","(o","(p"/)
fig_out    ="pdf";"x11"

f = addfile(gtopfile,"r")
phis   = f->PHIS({lats(na):latn(na)},{lonl(na):lonr(na)})
phis   = phis/9.8   ;convert unit from m2/s2 to gpm
nmonth = dimsizes(months)
nlat   = dimsizes(phis&lat)
nlon   = dimsizes(phis&lon)
nlev   = dimsizes(lev)
nvar   = dimsizes(draw_var)
ncase  = dimsizes(case1)

f = addfile(filename(0),"r")
if(.not.(month_option)) then 
time = cd_calendar(f->time,0)
select_time = ind(time(:,1).ge.month_s.and.time(:,1).le.month_e)
ntime = dimsizes(select_time)
var   = new((/ncase,nvar,ntime ,nlat,nlon/),double)
end if
var_m = new((/ncase,nvar,nmonth,nlat,nlon/),double)

if(uv_option) then 
uvar = new((/ncase,nmonth,nlat,nlon/),float)
vvar = new((/ncase,nmonth,nlat,nlon/),float)
uvari = new((/ncase,nmonth,nlat,nlon/),float)
vvari = new((/ncase,nmonth,nlat,nlon/),float)
end if
if(duvdt_option) then 
uvar = new((/ncase,nvar,nmonth,nlat,nlon/),double)
vvar = new((/ncase,nvar,nmonth,nlat,nlon/),double)
end if

;the number of the panel plot
    plot     = new((/nvar*nmonth/),graphic)
    gtop     = new((/nvar*nmonth/),graphic)
    line     = new((/nvar*nmonth/),graphic)
    vect     = new((/nvar*nmonth/),graphic)
    wind2    = new((/nvar*nmonth/),graphic)

;set the area of the box
maxlon = 105
minlon = 70
maxlat = 40
minlat = 25
lonx = (/ minlon, maxlon, maxlon, minlon, minlon /)
latx = (/ minlat, minlat, maxlat, maxlat, minlat /)

;================================================================
;read data
;====================================================================
if(uv_option) then
do nc = 0, ncase-1, 1
fu = addfile(path+"/analysis/mdata/" + case1(nc) + "-Clim_2month_ave_U.nc","r")
fv = addfile(path+"/analysis/mdata/" + case1(nc) + "-Clim_2month_ave_V.nc","r")
uvar(nc,:,:,:) = fu->month_ave(:,{lev(nl)},{lats(na):latn(na)},{lonl(na):lonr(na)}) ;get an array (ncase,nmonth,nlat,nlon)
vvar(nc,:,:,:) = fv->month_ave(:,{lev(nl)},{lats(na):latn(na)},{lonl(na):lonr(na)}) ;get an array (ncase,nmonth,nlat,nlon)
uvari(nc,:,:,:) = fu->month_vari(:,{lev(nl)},{lats(na):latn(na)},{lonl(na):lonr(na)}) ;get an array (ncase,nmonth,nlat,nlon)
vvari(nc,:,:,:) = fv->month_vari(:,{lev(nl)},{lats(na):latn(na)},{lonl(na):lonr(na)}) ;get an array (ncase,nmonth,nlat,nlon)
end do
end if

if(month_option) then
do nc = 0, ncase-1, 1
    print(filename(nc))
    f = addfile(filename(nc),"r")
    if(var_option.le.0) then
        do nv = 0, nvar-2,1
        if(nmonth.eq.1) then 
        var_m(nc,nv,0,:,:)  = f->$var_name(nv)$({lev(nl)},{lats(na):latn(na)},{lonl(na):lonr(na)}) ;get an array (ncase,nmonth,nlat,nlon)
        else
        var_m(nc,nv,:,:,:)  = f->$var_name(nv)$(:,{lev(nl)},{lats(na):latn(na)},{lonl(na):lonr(na)}) ;get an array (ncase,nmonth,nlat,nlon)
        end if
        end do
    else
        if(var_option.eq.10) then 
        var_m(nc,0:nvar-1,:,:,:)  = f->$var_name(nnv)$(select,:,{lats(na):latn(na)},{lonl(na):lonr(na)}) ;get an array (ncase,nmonth,nlat,nlon)
        else
        var_m(nc,0:nvar-2,:,:,:)  = f->$var_name(nnv)$(select,:,{lev(nl)},{lats(na):latn(na)},{lonl(na):lonr(na)}) ;get an array (ncase,nmonth,nlat,nlon)
        end if
        if(duvdt_option) then 
        uvar(nc,0:nvar-2,:,:,:)  = f->dudt(select,:,{lev(nl)},{lats(na):latn(na)},{lonl(na):lonr(na)}) ;get an array (ncase,nmonth,nlat,nlon)
        vvar(nc,0:nvar-2,:,:,:)  = f->dvdt(select,:,{lev(nl)},{lats(na):latn(na)},{lonl(na):lonr(na)}) ;get an array (ncase,nmonth,nlat,nlon)
        end if 
    end if
end do 
else
do nc = 0, ncase-1, 1
    f = addfile(filename(nc),"r")
    if(var_option.le.0) then
        do nv = 0, nvar-2,1
        var(nc,nv,:,:,:)  = f->$var_name(nv)$(select_time,{lev(nl)},{lats(na):latn(na)},{lonl(na):lonr(na)}) ;get an array (ncase,nmonth,nlat,nlon)
        end do
    else
        var(nc,0:2,:,:,:)  = f->$var_name(nnv)$(select,select_time,{lev(nl)},{lats(na):latn(na)},{lonl(na):lonr(na)}) ;get an array (ncase,nmonth,nlat,nlon)
    end if
end do 
;calc ealy(56) and late(78) stage of the summer 
select_time := ind(time(:,1).ge.5.and.time(:,1).le.6)
var_m(:,:,0,:,:) = dim_avg_n_Wrap(var(:,:,select_time,:,:),2)
select_time := ind(time(:,1).ge.7.and.time(:,1).le.8)
var_m(:,:,1,:,:) = dim_avg_n_Wrap(var(:,:,select_time,:,:),2)
printVarSummary(var_m)
end if

;var_m(:,nvar-1,:,:,:) = dim_sum_n(var_m(:,0:(nvar-2),:,:,:),1)
if(duvdt_option) then 
uvar(:,nvar-1,:,:,:) = dim_sum_n(uvar(:,0:(nvar-2),:,:,:),1)
vvar(:,nvar-1,:,:,:) = dim_sum_n(vvar(:,0:(nvar-2),:,:,:),1)
uvar = uvar*100000
vvar = vvar*100000
end if

if(var_option.eq.-6) then 
    var_m = var_m*10^5
end if

if(var_option.eq.-1) then 
    var_m = var_m*10^10
end if

if(var_option.eq.0) then 
    var_m = var_m*24*3600 ;convert units of Q from K/s to K/Day 
end if

if(var_option.ge.1.and.var_option.lt.10) then 
if(nnv.eq.0) then
    var_m = var_m*10^3
end if
if(nnv.eq.1.or.nnv.eq.4) then
    var_m = var_m*10^6
end if
if(nnv.eq.2) then
    var_m = var_m*10^6
end if
if(nnv.eq.3) then
    var_m = var_m*10^12
end if
end if
printVarSummary(var_m)

if(var_option.eq.10) then 
    var_m = var_m*100 
end if

if(diff) then 
do nc = 1, ncase-1, 1
    var_m(nc,:,:,:,:) = var_m(nc,:,:,:,:) - var_m(0,:,:,:,:)
    if(uv_option) then 
    uvari = where(abs(uvari).le.0.000001,0.1,uvari)
    vvari = where(abs(vvari).le.0.000001,0.1,vvari)
    uprob = ttest(uvar(0,:,:,:),uvari(0,:,:,:),nsample,uvar(1,:,:,:),uvari(1,:,:,:),nsample,True,False)
    vprob = ttest(vvar(0,:,:,:),vvari(0,:,:,:),nsample,vvar(1,:,:,:),vvari(1,:,:,:),nsample,True,False)
    print(uprob(0,20:25,40:45))
    
    uvar(nc,:,:,:) = uvar(nc,:,:,:) - uvar(0,:,:,:)
    vvar(nc,:,:,:) = vvar(nc,:,:,:) - vvar(0,:,:,:)
    
    siglvl = 0.05
    ules = mask(uvar(1,:,:,:),((uprob.lt.siglvl).or.(vprob.lt.siglvl)),False)  ;Keep less significant values 
    vles = mask(vvar(1,:,:,:),((uprob.lt.siglvl).or.(vprob.lt.siglvl)),False)
    uvar(1,:,:,:) = mask(uvar(1,:,:,:),((uprob.lt.siglvl).or.(vprob.lt.siglvl)),True) ;Keep significant values 
    vvar(1,:,:,:) = mask(vvar(1,:,:,:),((uprob.lt.siglvl).or.(vprob.lt.siglvl)),True)
    copy_VarMeta(uvar(0,:,:,:),ules)
    copy_VarMeta(uvar(0,:,:,:),vles)
    end if

    if(duvdt_option) then 
    uvar(nc,:,:,:,:) = uvar(nc,:,:,:,:) - uvar(0,:,:,:,:)
    vvar(nc,:,:,:,:) = vvar(nc,:,:,:,:) - vvar(0,:,:,:,:)
    end if
end do 
end if

;==============================================================
;draw figure in twelve months (one month is a fgure)
;==================================================================
    wks = gsn_open_wks(fig_out,fig_name)
if(var_option.lt.10)
    gsn_define_colormap(wks,"BlueDarkRed18")
    ;blue and red, has 18 colors,2-10 is blue
else
    gsn_define_colormap(wks,"precip3_16lev")
    ;blue and yellow and red, has 17 colors,2-18,2 is white
end if

;define the thickness and height of the title,tick and label
if(na.eq.2) then 
   tick_font      = 0.01
   subtitle_font  = 0.01
   title_font     = 0.01
   vcref_font     = 0.007
   tick_thick     = 8.0
   subtitle_thick = 8.0  ;not have this attribute
   title_thick    = 5.0
   vc_thick       = 2.5
   mp_thick       = 1.5
   font_index     = 22
   vc_distance  = 0.012
   vc_head_size = 0.005
else
   tick_font      = 0.03
   subtitle_font  = 0.03
   title_font     = 0.03
   vcref_font     = 0.015
   tick_thick     = 8.0
   subtitle_thick = 8.0  ;not have this attribute
   title_thick    = 5.0
   vc_thick       = 2.5
   mp_thick       = 3.0
   font_index     = 22
   vc_distance  = 0.02
   vc_head_size = 0.01
end if

    res                  = True
    res@gsnFrame         = False
    res@gsnDraw          = False
    res@gsnMaximize      = True
    res@gsnAddCyclic     = False
    res@gsnPaperOrientation = "portrait"
    ;res@vpHeightF        = 0.25
    ;res@vpWidthF         = 0.8

;-------set the attribute of the map-------------------
    res@mpCenterLonF     = 180.
    res@mpMaxLatF        = latn(na) 
    res@mpMinLatF        = lats(na)
    res@mpMaxLonF        = lonr(na)
    res@mpMinLonF        = lonl(na)
    res@gsnMajorLatSpacing = 15
    res@gsnMajorLonSpacing = 30
    res@mpFillOn         = False
    ;res@mpLandFillColor = "gray"
    ;res@mpFillDrawOrder = "PreDraw"
    res@mpGeophysicalLineThicknessF = mp_thick
    res@mpGeophysicalLineColor      = "black";"white"

;--------set the form of the coordinate-----------------
    res@tmBorderThicknessF  = mp_thick
    res@tmXBLabelFont   = font_index
    res@tmYLLabelFont   = font_index
    res@tmXBLabelFontHeightF     = tick_font
    ; res@tmXBLabelFontAspectF   = 1.6
    res@tmXBLabelFontThicknessF  = tick_thick
    res@tmYLLabelFontHeightF     = tick_font
    ; res@tmYLLabelFontAspectF   = 1.3
    res@tmYLLabelFontThicknessF  = tick_thick
    
    res@tmXBMajorThicknessF     = mp_thick
    res@tmYLMajorThicknessF     = mp_thick
    ;  res@tmXBMajorOutwardLengthF = -0.
    ;  res@tmYLMajorOutwardLengthF = -0.
    ;  res@tmYRMajorOutwardLengthF = -0.
      
    res@tmXBMinorThicknessF     = mp_thick
    res@tmYLMinorThicknessF     = mp_thick
    ;  res@tmXBMinorOutwardLengthF = -0.
    ;  res@tmYLMinorOutwardLengthF = -0.
    ;  res@tmYRMinorOutwardLengthF = -0.

;---------set the attribute of the contour-----------------
    res@cnFillOn         = True
    res@cnLinesOn        = False ;True
    res@cnLineLabelsOn   = False
    res@cnInfoLabelOn    = False
    ;res@cnLineThicknessF = 0
    ;res@gsnContourZeroLineThicknessF = 4.0
    ;res@cnLineColor      = "blue"
   
    ;res@cnLevelSelectionMode = "AutomaticLevels"   ; set manual contour levels
    ;res@cnLevelSelectionMode = "ExplicitLevels"   ; set manual contour levels
    ;res@cnLevels             = (/-5,-4.5,-4,-3.5,-3,-2.5,-2,-1.5,-1,-0.5,0,0.5,1,1.5,2,2.5,3,3.5,4,4.5,5/)
    ;res@cnLevels             = ispan(0,60,10)
    ;res@cnFillColors         = (/-1,20,47,57,94,127,152/)
    ;res@cnLevelSelectionMode  = "ManualLevels" ; set manual contour levels
    ;res@cnMinLevelValF        = 1          ; set min contour level
    ;res@cnMaxLevelValF        = 13 ;32        ; set max contour level
    ;res@cnLevelSpacingF       = 1        ; set contour interval

    res@gsnSpreadColors      = False  ;True              ; turn of the full color map
    res@gsnSpreadColorStart  = 11                ; start at color 17
    res@gsnSpreadColorEnd    = 2                ; end at color 200
    
    if(var_option.ge.1) then
    res@lbLabelBarOn         = False   ; the label bar
    else
    res@lbLabelBarOn         = True   ; the label bar
    end if
    res@lbOrientation        = "Horizontal"
    res@lbLabelFontHeightF   = tick_font              ; make labels smaller
    res@lbLabelFont          = font_index              ; make labels smaller
    res@lbLabelStride        = 1
    res@lbBoxLineThicknessF  = mp_thick-1

    res@pmLabelBarZone               = 0
    res@pmLabelBarOrthogonalPosF     = 0.15
    res@pmLabelBarParallelPosF       = 0.5

;--------set the attribute of vector--------------
    resvc                  = True
    resvc@gsnDraw          = False
    resvc@gsnFrame         = False
    resvc@vcGlyphStyle               = "LineArrow"  ;"CurlyVector"
    resvc@vcVectorDrawOrder          = "PostDraw"
    resvc@vcLineArrowThicknessF      = vc_thick
    resvc@vcMonoLineArrowColor       = True
    resvc@vcLineArrowColor           = "gray20"
    resvc@vcMinDistanceF             = vc_distance
    resvc@vcRefLengthF               = 0.05           ; define length of vec ref
    resvc@vcLineArrowHeadMinSizeF   = vc_head_size
    resvc@vcLineArrowHeadMaxSizeF   = vc_head_size
    ;resvc@vcRefAnnoSide              = "Bottom"          
    ;resvc@vcRefAnnoJust              = "TopRight"
    ;resvc@vcRefMagnitudeF            = 10.0             ; define vector ref mag
    ;resvc@vcRefAnnoString2           = "10m/s"
    resvc@vcRefAnnoZone              = 0     ;set the positional origin in the center of the plot
    resvc@vcRefAnnoOrthogonalPosF    = 0.3           ; move ref vector along Y-axis
    resvc@vcRefAnnoParallelPosF      = 0.5            ; move ref vector along X-axis
    resvc@vcRefAnnoPerimOn           = False         ;close the border
    resvc@vcRefAnnoFont              = font_index
    resvc@vcRefAnnoFontHeightF       = vcref_font
    resvc@vcRefAnnoString1On         = False
    resvc@vcRefAnnoString2On         = True
    resvc@gsnCenterString      = ""
    resvc@gsnLeftString    = " "
    resvc@gsnRightString   = " "

    resvc2 = resvc
    resvc2@vcLineArrowColor           = "grey"

;--------set the attribute of polygon--------------
    lnres                      = True
    lnres@gsLineColor          = "black"
    lnres@gsLineDashPattern    = 0
    lnres@gsLineThicknessF     = 4.0
    ;lnres@gsLineLabelString    = "TP"

;--------set the attribute of gtop--------------
    res_gtop                  = True
    res_gtop@gsnDraw          = False
    res_gtop@gsnFrame         = False
    res_gtop@cnFillOn         = False
    res_gtop@cnLinesOn        = True      ; turn off contour lines
    res_gtop@cnLineLabelsOn   = False      ; turn off contour line labels
    res_gtop@cnInfoLabelOn    = False
    res_gtop@cnLineThicknessF = 4.0
    res_gtop@cnLineColor      = "black"
    res_gtop@cnLevelSelectionMode  = "ExplicitLevels" ; set manual contour levels
    res_gtop@cnLevels         = (/1500/)
    res_gtop@gsnCenterString      = ""
    res_gtop@gsnLeftString    = " "
    res_gtop@gsnRightString   = " "

;------------------------------------------------------------------
;draw the subgraph and change the left and right titles
;-----------------------------------------------------------------------
   ; res@tiMainString         = fig_title + "in" + months(m)
    ;res@tiMainFontHeightF    = 0.04
   ; res@tiMainFontColor      = "black"
    res@gsnCenterString      = ""
    res@gsnStringFont         = font_index
    res@gsnStringFontHeightF = subtitle_font

    resp  = True    
    resp@gsnMaximize   = True
    resp@gsnPaperOrientation = "landscape" ;"portrait"
    if(var_option.ge.1) then
    resp@gsnPanelLabelBar = True
    else
    resp@gsnPanelLabelBar = False
    end if
    resp@lbOrientation     = "Vertical" ;"Horizontal" ;
    resp@pmLabelBarWidthF  = 0.05
    resp@pmLabelBarHeightF = 0.8
    resp@lbLabelFont        = font_index              ; make labels smaller
    resp@lbLabelFontHeightF = 0.015 
    resp@lbLabelFontThicknessF = tick_thick
    resp@txFontHeightF = title_font 
    resp@txFontThicknessF = title_thick

if(duvdt_option) then 
vcref         = (/(/5 ,2 ,2 /), \  ;the level of 925hpa    ctrl,nudg,diff
                  (/10,4 ,4 /), \  ;the level of 850hpa    ctrl,nudg,diff
                  (/7 ,2 ,2 /), \  ;the level of 700hpa    ctrl,nudg,diff
                  (/7 ,2 ,2 /), \  ;the level of 500hpa    ctrl,nudg,diff
                  (/10,4 ,4 /)/)   ;the level of 200hpa    ctrl,nudg,diff
end if

if(uv_option) then 
vcref         = (/(/10,5 ,5 /), \  ;the level of 925hpa    ctrl,nudg,diff
                  (/20,5 ,5 /), \  ;the level of 850hpa    ctrl,nudg,diff
                  (/7 ,2 ,2 /), \  ;the level of 700hpa    ctrl,nudg,diff
                  (/7 ,2 ,2 /), \  ;the level of 500hpa    ctrl,nudg,diff
                  (/40,10,10/)/)   ;the level of 200hpa    ctrl,nudg,diff
end if

if(var_option.eq.-6) then ;forc
    minlvl = (/-0.4/);-4 
    maxlvl = (/ 0.4/); 4 
    spacig = (/0.05/);0.5
end if

if(var_option.eq.-1) then ;forc
    minlvl = (/-14,-14,-14,-14/);-8,-8,-8,-8,
    maxlvl = (/ 14, 14, 14, 14/); 8, 8, 8, 8,
    spacig = (/ 2 , 2 , 2 , 2 /); 1, 1, 1, 1,
end if

if(var_option.eq.0) then ;Q
    minlvl = (/-2.1,-2.1,-2.1/);
    maxlvl = (/ 2.1, 2.1, 2.1/);
    spacig = (/ 0.3, 0.3, 0.3/);
end if
    
if(var_option.ge.1.and.var_option.lt.10) then ;dzdt
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
if((fnc.eq.0)) then  ;.and.diff 
    minlvl = (/-32,-32,-32,-32/);
    maxlvl = (/ 32, 32, 32, 32/);
    spacig = (/ 4 , 4 , 4 , 4 /);
else
    minlvl = (/-8,-8,-8,-8/);-16,-16,-16,-16
    maxlvl = (/ 8, 8, 8, 8/); 16, 16, 16, 16
    spacig = (/ 1, 1, 1, 1/); 2 , 2 , 2 , 2 
end if
end if
if(nnv.eq.3) then ;dbdt
if((fnc.eq.0)) then  ;.and.diff 
    minlvl = (/-24,-24,-24,-24/);
    maxlvl = (/ 24, 24, 24, 24/);
    spacig = (/  3,  3,  3,  3/);
else
    minlvl = (/-24,-24,-24,-24/);
    maxlvl = (/ 24, 24, 24, 24/);
    spacig = (/  3,  3,  3,  3/);
end if
end if
if(nnv.eq.4) then ;dvdt
    minlvl = (/-35,-35,-35,-35/);-8,-8,-8,-8,
    maxlvl = (/ 35, 35, 35, 35/); 8, 8, 8, 8,
    spacig = (/ 5 , 5 , 5 , 5 /); 1, 1, 1, 1,
end if
end if
    
if(var_option.eq.10) then ;Q
    minlvl := (/0 ,0 ,0 ,0 ,0 /);
    maxlvl := (/90,90,90,90,90/);
    spacig := (/5 ,5 ,5 ,5 ,5 /);
end if

    ;res@cnFillPalette = "BlueDarkRed18"
   ;blue and red, has 18 colors,2-10 is blue
    ;res@cnFillPalette = "precip3_16lev"
    ;blue and yellow and red, has 17 colors,2-18,2 is white
    if(var_option.lt.10)
    res@cnFillColors  = (/2,3,4,5,6,7,8,9,12,13,14,15,16,17,18,19/)
    end if

do fnc = 0,1,1
do nv = 0,nvar-1,1
do nm = 0,nmonth-1,1
    np = nm
   ; np = nm*3 + nv
   ; np = nv*nmonth + nm
    res@gsnLeftString   = pre_case(np) + ") " + case2(fnc) + " " + months(nm) 
    if(var_option.ge.1) then 
    res@gsnRightString  = lev(nl) + "hPa " + draw_var(nv) + " " + var_name(nnv) + " (" + unit(nnv) + ")"
    else
    res@gsnRightString  = lev(nl) + "hPa " + draw_var(nv) + " (" + unit(nv) + ")"
    end if
    res@gsnSpreadColors       = False              ; turn of the full color map
    res@cnLevelSelectionMode  = "ManualLevels" ; set manual contour levels
    res@cnLevelSpacingF       := spacig(nv)        ; set contour interval
    res@cnMaxLevelValF        := maxlvl(nv) ;32    ; set max contour level
    res@cnMinLevelValF        := minlvl(nv)       ; set min contour level
    plot(np) = gsn_csm_contour_map_ce(wks,var_m(fnc,nv,nm,:,:),res)
    gtop(np) = gsn_csm_contour(wks,phis,res_gtop)
    overlay(plot(np),gtop(np))
    if(uv_option) then 
    resvc@vcRefMagnitudeF      = vcref(nl,fnc)             ; define vector ref mag
    resvc@vcRefAnnoString2     = vcref(nl,fnc)+"m/s"
    vect(np) = gsn_csm_vector(wks,uvar(fnc,nm,:,:),vvar(fnc,nm,:,:),resvc)
    overlay(plot(np),vect(np))
        if(diff.and.fnc.gt.0)
        resvc2@vcRefMagnitudeF      = vcref(nl,fnc)             ; define vector ref mag
        resvc2@vcRefAnnoString2     = vcref(nl,fnc)+"m/s"
        wind2(np)   = gsn_csm_vector(wks,ules(nm,:,:),vles(nm,:,:),resvc2)
        overlay(plot(np),wind2(np))
        end if
    end if
    if(duvdt_option) then 
    resvc@vcRefMagnitudeF      = vcref(nl,fnc)             ; define vector ref mag
    resvc@vcRefAnnoString2     = vcref(nl,fnc)+"x10~S~-5~N~m/s~S~2~N~"
    vect(np) = gsn_csm_vector(wks,uvar(fnc,nv,nm,:,:),vvar(fnc,nv,nm,:,:),resvc)
    overlay(plot(np),vect(np))
    end if
    if(case_option.eq.0) then 
    line(np) = gsn_add_polyline( wks, plot(np), lonx, latx, lnres )
    end if 
    print(max(var_m(fnc,nv,nm,:,:)))
    print(min(var_m(fnc,nv,nm,:,:)))
end do 
    gsn_panel(wks,plot,(/nmonth,1/),resp)
end do 

;    resp@txString      = fig_title
;    if(nmonth.eq.1) then
;    gsn_panel(wks,plot,(/nvar,nmonth/),resp)
;    else
;    gsn_panel(wks,plot,(/nmonth,3/),resp)
;    end if
end do
end

