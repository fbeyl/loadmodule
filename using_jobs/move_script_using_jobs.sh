date +"%T";
#submit $i job
jobid=$(zowe zos-jobs submit stdin < copy_from_pdse_to_ussfile_job --rff jobid --rft string --wfo)
echo "Submitted copy to uss job, JOB ID is $jobid"
#wait for job to go to output
echo "Job completed in OUTPUT status. Checking return-code"
retcode=$(zowe zos-jobs view job-status-by-jobid "$jobid" --rff [retcode] --rft string)
echo ${retcode:3:4}
if [ ${retcode:3:4} = "0000" ]
then
    echo "Start download from uss"
    zowe zos-files download uss-file "/z/z26544/load.from.pdse/JSONGEN2" -b -f "load/jsongen2"
    echo "Start upload to ussfile"
    zowe zos-files upload file-to-uss "load/jsongen2" "/z/z26544/load.to.pdse/jsongen2" -b
fi
#submit $i job
jobid=$(zowe zos-jobs submit stdin < copy_from_ussfile_to_pdse_job --rff jobid --rft string --wfo)
echo "Submitted copy to pdse job, JOB ID is $jobid"
#wait for job to go to output
echo "Job completed in OUTPUT status. Checking return-code"
retcode=$(zowe zos-jobs view job-status-by-jobid "$jobid" --rff [retcode] --rft string)
echo ${retcode:3:4}
if [ ${retcode:3:4} = "0000" ]
then
    echo "Loadmodule copied to final destination"
fi
date +"%T";
