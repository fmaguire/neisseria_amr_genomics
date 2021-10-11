import pandas as pd
import tqdm
import subprocess
from pathlib import Path
import urllib
import urllib.request


if __name__ == "__main__":

    output_dir = Path('neisseria_assemblies')
    if not output_dir.exists():
        output_dir.mkdir()
    metadata_dir = Path('neisseria_assemblies/metadata')
    if not metadata_dir.exists():
        metadata_dir.mkdir()

    qc_df = pd.read_csv('Supplementary_File4_qc_661k.txt', sep='\t')
    qc_df = qc_df.set_index('sample_id')

    # filter to nessiera only
    qc_df = qc_df[qc_df['species'].str.contains("Neisseria")]
    qc_df = qc_df[(qc_df['Contamination'] < 1) & (qc_df['N50'] > 65_000)]
    qc_df.to_csv(metadata_dir / "qc.tsv", sep='\t')
    download_accs = qc_df.index


    paths = pd.read_csv('sampleid_assembly_paths.txt', sep='\t', names=['sample_id', 'ftp_path'])
    paths = paths.set_index('sample_id')
    paths = paths.loc[download_accs]
    paths.to_csv(metadata_dir / "paths.tsv", sep='\t')


    checklist = pd.read_csv('checklist.chk', sep='\s+', names=['md5sum', 'assembly'])
    checklist = checklist[checklist['assembly'].str.contains('contigs.fa.gz')]
    checklist['assembly'] = checklist['assembly'].astype(str).str.split('/').str.get(-1)
    checklist['sample_id'] = checklist['assembly'].str.split('.').str.get(0)
    checklist = checklist.set_index('sample_id')
    checklist = checklist.loc[download_accs]
    checklist.to_csv(metadata_dir / "checklist.tsv", sep='\t')
    for sample_id, ftp_path in tqdm.tqdm(paths.iterrows()):
        downloaded_path = output_dir / f"{sample_id}.contigs.fa.gz"
        ftp_path = ftp_path['ftp_path']
        ftp_path = ftp_path.replace('/ebi/ftp/', 'http://ftp.ebi.ac.uk/')
        if not downloaded_path.exists():
            urllib.request.urlretrieve(ftp_path, downloaded_path)
        md5sum_result = subprocess.run(['md5sum', downloaded_path], capture_output=True)
        md5sum_result = md5sum_result.stdout.decode('utf-8').split()[0]
        if md5sum_result != checklist.loc[sample_id, 'md5sum']:
            downloaded_path.unlink()
            print(sample_id)

