testpath=$(cd "$(dirname "$0")"; pwd)
projectpath=${testpath}/../..

# get rtidb ver
rtidbver=`echo \`grep "RTIDB_VERSION" ${projectpath}/CMakeLists.txt|awk '{print $2}'|awk -F ')' '{print $1}'\`|sed 's/\ /\./g'`
if [ $1 ];then
    rtidbver=$1
fi

# setup test env
sh ${testpath}/setup.sh ${rtidbver}
source ${testpath}/env.conf

# setup xmlrunner
if [ -d "${testpath}/xmlrunner" ]
then
    echo "xmlrunner exist"
else
    echo "start install xmlrunner...."
    wget -O ${projectpath}/thirdsrc/xmlrunner.tar.gz http://pkg.4paradigm.com:81/rtidb/dev/xmlrunner.tar.gz >/dev/null
    tar -zxvf ${projectpath}/thirdsrc/xmlrunner.tar.gz -C ${testpath} >/dev/null
    echo "install xmlrunner done"
fi

# setup ddt
if [ -f "${testpath}/libs/ddt.py" ]
then
    echo "ddt exist"
else
    echo "start install ddt...."
    wget -O ${projectpath}/thirdsrc/ddt.tar.gz http://pkg.4paradigm.com:81/rtidb/dev/ddt.tar.gz >/dev/null
    tar -zxvf ${projectpath}/thirdsrc/ddt.tar.gz -C ${testpath}/libs >/dev/null
    echo "install ddt done"
fi

# setup zk
if [ -d "${projectpath}/thirdsrc/zookeeper-3.4.10" ]
then
    echo "zookeeper exist"
else
    echo "start install zookeeper...."
    wget -O ${projectpath}/thirdsrc/zookeeper-3.4.10.tar.gz http://pkg.4paradigm.com:81/rtidb/dev/zookeeper-3.4.10.tar.gz >/dev/null
    tar -zxvf ${projectpath}/thirdsrc/zookeeper-3.4.10.tar.gz -C ${projectpath}/thirdsrc >/dev/null
    echo "install zookeeper done"
fi

# run integration test
python ${testpath}/runall.py

# reset test env
sh ${testpath}/setup.sh