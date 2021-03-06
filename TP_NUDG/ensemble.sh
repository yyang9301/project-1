#!/bin/bash

#-----------------------------------------------
#   This is a shell script for setting up a
# multi-sub ensemble tasks by perturbing the 
# initial T field with white noise. You should 
# set the basic parameters as below. Good Luck!
#
# 2015-11-17 Created
# 2017-01-16 Change to fit HPC4
# 2017-02-17 Change to fit branch pert
#
#                      A L_Zealot Product
#-----------------------------------------------

#=========================================================
# 1. The following namelist variables must be set properly
# in your case env_run.xml
#
#   RUN_TYPE="hybrid" (and relavant configurations)
#
# 2. Please set "ncdata" namelist variable in user_nl_cam,
# which share the same name as BRCH_NAME 
#
# 3. Please check your specific inititial conditions and restart
# files are in the proper dir, also provide your rpointers 
# in a separate dir
#=========================================================

#*************************************************************
#--------------Below for user defined part--------------------
#*************************************************************
# source ~/.bashrc_cesm
# alias task="/opt/gridview/pbs/dispatcher/bin/qstat -u yangsong3"

# Workspace Path
WPATH=/HOME/sysu_hjkx_ys/WORKSPACE/hank/cesm/EWA/wne_dailyout_2yr

# Case Name
CASENAME=`basename $WPATH`

# Storage Path
SPATH=/HOME/sysu_hjkx_ys/WORKSPACE/hank/cesm/EWA/data

# Storage Dir Prefix 
SDPRE=wne_nudging_

# Init Dir PATH (must be a separate dir)
BRCH_DIR=$WPATH/brch

# Init File Name (same as ncdata in user_nl_cam)
BRCH_NAME=B2000_f19g16_CP_CTRL.cam.r.0250-01-01-00000.nc

# Ensemble Members
STRT_ESM=2
END_ESM=10

# Standard Divation of Normal Distributed Perturbation in T Field (Kelvin)
T_PURB=0.01


#*************Below to execute the changes*********************
# WARNING:
#   If you are willing to change anything below, you need to be
# VERY CAREFUL to do so.
#*************************************************************
echo "                                                              "
echo "*******************CESM ENSEMBLE RUN SCRIPT*******************"
echo "You may use this script with full access, and any kind of     "
echo "redistribution. It's totally Open-sourced!                    "
echo "                                                              "
echo "     Contact: http://met.sysu.edu.cn/GloCli/Team/?page_id=1008"
echo "                                            A L_Zealot Product"
echo "                                                     2017/12/2"
echo "**************************************************************"
echo "                                                              "

echo "Current working PATH: ${WPATH}"
if [ ! -d $BRCH_DIR ]; then
    mkdir $BRCH_DIR
fi
cp /HOME/sysu_hjkx_ys/WORKSPACE/hank/cesm/EWA/restart_file/B2000_f19g16_CP_CTRL.cam.r.0250-01-01-00000.nc $BRCH_DIR

# Init DIR Validation
if [ $BRCH_DIR == "" ] || [ ! -d $BRCH_DIR ]; then
    echo "PATH: \"${BRCH_DIR}\" NO FOUND! Please check it!"
    exit 1
fi

# Backup rpointer files and initial files 
RP_DIR=${WPATH}/rpoint
if [ ! -d $RP_DIR ]; then
    mkdir $RP_DIR
fi
cp /HOME/sysu_hjkx_ys/WORKSPACE/hank/cesm/EWA/restart_file/rpoint* $RP_DIR
cp  $RP_DIR/* ${WPATH}/run/

if [ ! -f  $BRCH_DIR/${BRCH_NAME}.org ]; then
    cp $BRCH_DIR/${BRCH_NAME} $BRCH_DIR/${BRCH_NAME}.org
else
    cp $BRCH_DIR/${BRCH_NAME}.org $BRCH_DIR/${BRCH_NAME}
fi


# Clean the cesm.log 
if [ -f  $WPATH/run/cesm.log ]; then
    rm $WPATH/run/cesm.log
fi


NCL_BRCH_PATH=\"${BRCH_DIR}/${BRCH_NAME}/\"
# Main Loop
for II in `seq $STRT_ESM $END_ESM`
do
    echo "ESM${II}/${END_ESM}, with restart condition: ${BRCH_NAME}, is processing!"
 
    # Perturb branch filed
    ncl -nQ pre_dir=$NCL_BRCH_PATH  \
        t_purb=$T_PURB              \
        /WORK/sysu_hjkx_ys/hank/cesm/EWA/ncl/perturbation.ncl

    cp $BRCH_DIR/${BRCH_NAME} $WPATH/run/
    # Submit task
    $WPATH/$CASENAME.run 
    echo "ESM${II}/${END_ESM}, with perturbated restart condition: ${BRCH_NAME}, has been submitted!"
    
    #Check status
    while [ ! -f "$WPATH/run/cesm.log" ]
    do
        TASK=`task | grep lzn`
        if [ -n "$TASK" ]; then
            echo "Task on but cesm.log not found, will try another time..."    
            sleep 60
        else
            echo "No task info and no cesm.log, error may occur..."
            exit
        fi
    done

    # Loop until finished
    while [ "1" == "1" ]
    do
        
        # Check status
        LOG_SIZE0=`ls -l ${WPATH}/run/cesm.log | awk '{ print $5 }'`
        echo "cesm.log with size ${LOG_SIZE0} byte detected."

        sleep 300
        
        LOG_SIZE1=`ls -l ${WPATH}/run/cesm.log | awk '{ print $5 }'`
        
        if [ "$LOG_SIZE0" -eq "$LOG_SIZE1" -a $LOG_SIZE1 -gt 102400 ]; then
            
            TASK=`task | grep lzn`
            if [ -n "$TASK" ]; then
                echo "Still found running task, wait next test or interupt.."
            else
                FINISH=$(date)" ESM${II}/${END_ESM} finished!!! "
                echo "                                  "
                echo "**********************************"
                echo $FINISH
                echo "**********************************"
                echo "                                  "
                
                # post process the output
                echo "Post process, moving history files..."
                if [ ! -d $SPATH ]; then
                    mkdir $SPATH
                fi
                mkdir $SPATH/${SDPRE}${II}
                mv $WPATH/run/*cam.h1* $SPATH/${SDPRE}${II}
                mv $WPATH/run/*cam.h0* $SPATH/${SDPRE}${II}
                mv $WPATH/run/*pop.h* $SPATH/${SDPRE}${II}
                mv $WPATH/run/cesm.log $SPATH/${SDPRE}${II}
                break

            fi
        else
            if [ "$LOG_SIZE0" -eq "$LOG_SIZE1" ]; then
                echo "Log file size increment stopped, please check if ESM${II}/${END_ESM} failed."
                exit
            else
                DIFF_LOG_SIZ=`expr $LOG_SIZE1 - $LOG_SIZE0`
                TIMER=$(date)" ${CASENAME} ESM${II}/${END_ESM} with size increment $DIFF_LOG_SIZ is still running..."
                echo $TIMER
            fi
        fi
    done
    
    # Move back the init file
    cp  $BRCH_DIR/${BRCH_NAME}.org $BRCH_DIR/$BRCH_NAME
 
    # Move back the rpointers
    cp  $RP_DIR/* ${WPATH}/run/
    
    if [ $II == $END_ESM ]; then
        echo "                                                              "
        echo "*******************CESM ENSEMBLE RUN SCRIPT*******************"
        echo "                                                              "
        echo "                                                              "
        echo "              CONGRATULATIONS!!! ALL TASKS DONE!!!            "
        echo "                                                              "
        echo "                                                              "
        echo "                                            A L_Zealot Product"
        echo "                                                    2016/12/18"
        echo "**************************************************************"
        echo "                                                              "
    fi
done
