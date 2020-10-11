# Notes pour installation et utilisation de STAR
***MAJ 16/06/2020***

## STAR :**
https://github.com/alexdobin/STAR
(currently installed: 2.7.3a on 11-05-2020)

#### **3 étapes:**

**1. Installer le logiciel STAR**

Nécessite que git soit installé
``` bash
sudo apt install git
```
Se mettre dans usr/local/bin
``` bash
sudo git clone https://github.com/alexdobin/STAR.git
```

Deux versions seront installées dans le bin/STAR/bin, une statique et une modifiable. On utilisera la modifiable.  
Avant de compiler STAR, on vérifie que gcc est installé ce qu'on vérifie avec la 1ere ligne decommande suivante par exmple:
``` bash
gcc --version
```
Puis on compile STAR:
```bash
cd STAR/source
sudo make STAR
```
Ne pas oublier de mettre à jour la variable path et de la sourcer pour pouvoir ensuite le lancer de n'importe quel repertoire:
> /usr/local/bin/STAR/bin/Linux_x86_64



**2. Construire les index:**
mai 2019, index pour reads de 75 bases sur release 30 d'ENCODE
janvier 2020, sur reads de 50 bases et release 32 d'ENCODE:

Creer un repertoire /home/Ressources_NGS
Télécharger les version PRI (primari) du génome (fasta version 38) et des annotations GENCODE (GTF version 30) file avec la fonction wget depuis le site https://www.gencodegenes.org/ 

```bash
# version fasta38 et release 30
#wget ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_30/GRCh38.primary_assembly.genome.fa.gz
#wget ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_30/gencode.v30.primary_assembly.annotation.gtf.gz

# version fasta 28 et release 32
wget ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_32/GRCh38.primary_assembly.genome.fa.gz
wget ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_32/gencode.v32.primary_assembly.annotation.gtf.gz

```

Decompresser la séquence fasta fa.gz et le fchier d'annotations gtf.gz
```bash
gunzip -k GRCh38.primary_assembly.genome.fa.gz # k pur garder le fchier .gz
gunzip -k gencode.v30.primary_assembly.annotation.gtf.gz
```

Creer un repertoire STAR_index qui contiendra les differents index de STAR 

On ajuste l'option --sjdbOverhang avec la taille des reads taille -1

En mai 2019, sur reads de 75 bases et release 30 d'ENCODE:
```bash
STAR --runThreadN 16 --runMode genomeGenerate --genomeDir ./STAR_index_75 \
--genomeFastaFiles ./GRCh38.primary_assembly.genome.fa \
--sjdbGTFfile ./gencode.v30.primary_assembly.annotation.gtf \
--sjdbOverhang 74
```

En janvier 2020, sur reads de 50 bases et release 32 d'ENCODE:
```bash
STAR --runThreadN 16 --runMode genomeGenerate --genomeDir ./STAR_r32_index_50 \
--genomeFastaFiles ./GRCh38.primary_assembly.genome.fa \
--sjdbGTFfile ./gencode.v32.primary_assembly.annotation.gtf \
--sjdbOverhang 49
```


**3. Faire tourner le programme STAR sur les outputs de fastp**
   
SI besoin, merger les lignes d'un même run par echantillon avec les scripts run_merge_fp et run_all_merge_fp.

```bash
~/run_all_merge_fp merged 
```
Puis faire tourner STAR sur ces fichiers mergés avec la commande donnant plusieurs outputs:
```bash
STAR --runThreadN 16 \
--genomeDir ~/Ressources_NGS/STAR_index_75 \
--readFilesIn 01_FastP/merged \
--readFilesCommand zcat \
--outFileNamePrefix output_prefix \
--outSAMtype BAM SortedByCoordinate \
--quantMode TranscriptomeSam GeneCounts \  #donne coordonnees sur transcriptome en plus du genome
--outSAMattributes All # les comptes de reads par gene (tous transcripts)
```
