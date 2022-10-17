#!/bin/bash
echo 本脚本由fjl编写
echo 包括从下载数据（ncbi），到生成质控后的multiqc报告以及得到rsem的比对结果
echo 中间文件只保留fastp的质控报告，fastqc的质控报告\&质控的fq文件\&比对的bam文件全都不保留
echo 如果是从下载数据开始，则每完成一个下载都会开始其分析，以免浪费时间
echo 脚本最后更新时间为10/8/2022
echo 

#脚本需要fastp sra-tools fastqc multiqc star rsem（确保二者的index都已经做好了,放在main下RsemIndex)
#截止脚本最后更新时间10.8，各软件版本为(没有指明就是用conda装的）
#sra-tools是下的官网的3.0
#fastp是0.23.2
#star是2.7
#rsem是1.3.3
#fastqc是0.11.9
#multiqc是1.13

#脚本使用
#脚本和库文件放一起(scc,sccd,scck放一起)
#构造如下目录和文件结构

#Main/
#  |
#  |
#  |------ RsemIndex/
#  |	   |
#  |	   |------sus/
#  |	   |------monkey/
#  |	   |------homo/
#  |	   |------mm/
#  |
#  |------ Project
#	   |
#	   |------*.name
#存放要求
#star和rsem的index放在main下
#sra数据放在项目文件夹下data，fastq数据放在data/fqdata，质控后数据放在qc
#项目名称的文件夹下放name结尾的文件
#脚本  从哪里开始（1dump2qc3rsemstar4report）   到哪里结束(同前面）    项目名称（文件夹名字）  物种（homo sus mus monkey)   测序策略se或者pe（se是1，pe是2）
#下面几个变量,自行调节
#新的环境，调节cunfnag和main，把上图的结构构建好就行了
main=/home/fjl/vql/
proj=$3/
dataat=/home/data/eed/
#dataat=${main}/$proj/data/fqdata/
#star rsem 用到
feature=$4
#index位置
index=${main}/RsemIndex/

#载入库文件
cunfang=~/script
. $cunfang/scck

#qc的时候，尾部是fastq还是fq，fastq就1
wb=1
if [ $wb == 1 ];then
	wb='fastq'
else
	wb='fq'
fi
#头剪几bp
cutbp=0
#线程数
xcs=16
#rsem调用star的位置
starweizhi=`which STAR`
starweizhi=`echo ${starweizhi%/*}`

#参数传递
layout=$5

mkdir ${main}/${proj}/data/fqdata  ${main}/${proj}/qc   ${main}/${proj}/count  ${main}/${proj}/qc/prep  ${main}/${proj}/qc/multirep ${main}/${proj}/qc/qrep  ${main}/${proj}/log/   -p 

#下载数据的检查要严格点，并且设置延时

#重定向报告

time1=`date +"%Y-%m-%d %H:%M:%S"`
rm -f ${main}/$proj/log/yichang

cat ${main}/$proj/*.name|while read x
do
exec > ${main}/$proj/log/$x.log 2>&1

let jl=$2-$1
b=-100
yichang=0
#dump
if [ $1 == 1 ]
then
       	if [ $1 == 1 ]
        then
                let b=$jl-1
        else
                let b=$b-1
        fi
	Dcheck Dump 
	if [ $yc -ne 0 ];
	then
		Yichang
		yichang=111
		continue
	fi
       
fi	
#qc
if [ $1 == 2 -o $b -ge 0 ]
then
	if [ $1 == 2 ]
	then 
		let b=$jl-1
		time1=`date +"%Y-%m-%d %H:%M:%S"`
	else
		let b=$b-1
	fi
	Dcheck Qc 
	
	if [ $yc == 0 ]
	then
		if [ -e ${main}/${proj}/data/$x*sra* ];then
			rm ${main}/${proj}/data/fqdata/$x* -r
		fi
	else
		Yichang
		yichang=111
		continue
	fi
	
fi

#star rsem
if [ $1 == 3 -o $b -ge 0 ]
then
        if [ $1 == 3 ]
        then
                let b=$jl-1
		time1=`date +"%Y-%m-%d %H:%M:%S"`
        else
                let b=$b-1
        fi
	Dcheck StarRsem  
	if [ $yc -ne 0 ];
	then
		Yichang
		yichang=111
		continue
	fi

fi

#report
if [ $1 == 4 -o $b -ge 0 ]
then
	if [ $1 == 4 ]
	then
		time1=`date +"%Y-%m-%d %H:%M:%S"`
	fi
	echo Fastqc for $x
	Dcheck Qreport
	if [ $yc == 0 ];
	then
		rm ${main}/${proj}/qc/$x* -r
	else
		Yichang
		yichang=111
		continue
	fi
	echo 完成Fastqc
fi
done

#样本多了会画非互动图，其实很不方便，得到的.1就是强制动图报告了，不会覆盖的
if [ $2 == 4 ]
then
	multiqc ${main}/${proj}/qc/qrep/ -o ${main}/${proj}/qc/multirep/
	multiqc ${main}/${proj}/qc/qrep/ -o ${main}/${proj}/qc/multirep/ --interactive
fi

time2=`date +"%Y-%m-%d %H:%M:%S"`


#删fq

#统计用时

tstart=`date -d "$time1" +%s`
tend=`date -d "$time2" +%s`
total=$(($tstart-$tend))
#报告位置
exec > ${main}/$proj/log/$x.time 2>&1
echo time consumed $total sec in total
if [ $yichang == 111 ]
then
	echo 异常存在
fi
