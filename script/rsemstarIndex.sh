#!/bin/bash
#生成的索引放RsemIndex下
#需要参考基因组文件夹里面，物种名字对应好，注释文件gtf结尾，参考基因组fa结尾

#mm,homo,sus

main=~/
xcs=16
if [ $3 == 'wget' -a $1 == 'zd' ];then
	#homo sapien
	wget -P ~ http://ftp.ensembl.org/pub/release-107/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz 
	wget -P ~ http://ftp.ensembl.org/pub/release-107/gtf/homo_sapiens/Homo_sapiens.GRCh38.107.gtf.gz 
	#sus
	wget -P ~ http://ftp.ensembl.org/pub/release-107/fasta/sus_scrofa/dna/Sus_scrofa.Sscrofa11.1.dna.toplevel.fa.gz
	wget -P ~ http://ftp.ensembl.org/pub/release-107/gtf/sus_scrofa/Sus_scrofa.Sscrofa11.1.107.gtf.gz
	#mm
	wget -P ~ http://ftp.ensembl.org/pub/release-107/fasta/mus_musculus/dna/Mus_musculus.GRCm39.dna.toplevel.fa.gz
	wget -P ~ http://ftp.ensembl.org/pub/release-107/gtf/mus_musculus/Mus_musculus.GRCm39.107.gtf.gz
	#monkey
	gzip -d  *.gtf.gz  *.fa.gz
else
        #homo sapien
        pget -p 16 http://ftp.ensembl.org/pub/release-107/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz 
        pget -p 16 http://ftp.ensembl.org/pub/release-107/gtf/homo_sapiens/Homo_sapiens.GRCh38.107.gtf.gz 
        #sus
        pget -p 16  http://ftp.ensembl.org/pub/release-107/fasta/sus_scrofa/dna/Sus_scrofa.Sscrofa11.1.dna.toplevel.fa.gz
        pget -p 16  http://ftp.ensembl.org/pub/release-107/gtf/sus_scrofa/Sus_scrofa.Sscrofa11.1.107.gtf.gz
        #mm
        pget -p 16 http://ftp.ensembl.org/pub/release-107/fasta/mus_musculus/dna/Mus_musculus.GRCm39.dna.toplevel.fa.gz
        pget -p 16 http://ftp.ensembl.org/pub/release-107/gtf/mus_musculus/Mus_musculus.GRCm39.107.gtf.gz
        #monkey
        gzip -d  *.gtf.gz  *.fa.gz
fi

starweizhi=`which STAR`
starweizhi=`echo ${starweizhi%/*}`

for i in homo mm sus monkey
do
	if [ $i == 'homo' ];then
		tmp='Homo'
	elif [ $i == 'mm' ];then
		tmp='Mus'
	elif [ $i == 'sus' ];then
		tmp='Sus'
	elif [ $i == 'monkey' ];then
		tmp="ffff"
	fi

	mkdir ${main}/refGenome/$i/
	mv ${tmp}*fa* ${tmp}*gtf* ${main}/refGenome/$i/
done


if [ $1 == 'zd' ];then
	for i in homo sus mm
	do
		mkdir ${main}/RsemIndex/$i/ -p
		indexZd
	done
else
	mkdir ${main}/RsemIndex/$1/ -p
	indexSd
fi


