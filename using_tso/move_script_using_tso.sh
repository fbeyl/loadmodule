#
# start tso session on lpar1
#
sko=$(zowe zos-tso start address-space --sko);
echo "Tso session: " $sko " started";
echo "Copy from pdse to ussfile";
resp=$(zowe zos-tso send address-space $sko --data "BPXBATCH SH cp  -X \"//'Z26544.LOAD2(JSONGEN2)'\" /z/z26544/load.from.pdse/JSONGEN2");
echo "Download from ussfile";
zowe zos-files download uss-file "/z/z26544/load.from.pdse/JSONGEN2" -b -f "load/jsongen2";
#
# stop tso session on lpar1
#
zowe zos-tso stop address-space $sko;
#
# start tso session on lpar2
#
sko=$(zowe zos-tso start address-space --sko);
echo "Tso session: " $sko " started";
echo "Upload to ussfile";
zowe zos-files upload file-to-uss "load/jsongen2" "/z/z26544/load.to.pdse/jsongen2" -b;
echo "Copy from ussfile to pdse";
resp=$(zowe zos-tso send address-space $sko --data "BPXBATCH SH cp  -X  /z/z26544/load.to.pdse/jsongen2 \"//'Z26544.LOAD3(JSONGEN2)'\"");
#
# stop tso session on lpar2
#
zowe zos-tso stop address-space $sko;