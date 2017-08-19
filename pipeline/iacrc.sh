type=`grep Disease_Type ../original/files|awk -F ' ' '{print$2}'`
if [ ${type} = 'continuous' ]
then getresult.sh ${1} ${2} ${3}
fi
if [ ${type} = 'classified' ]
then getresult_cla.sh ${1} ${2} ${3}
fi
if [ ${type} = 'classified_cov' ]
then getresult_cla_cov.sh ${1} ${2} ${3}
fi
