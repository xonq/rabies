"""
This part of the workflow collects the phylogenetic tree and annotations to
export a Nextstrain dataset.

See Augur's usage docs for these commands for more details.
"""

rule export:
    """Exporting data files for auspice"""
    input:
        tree = "results/tree.nwk",
        metadata = "data/metadata.tsv",
        branch_lengths = "results/branch_lengths.json",
        nt_muts = "results/nt_muts.json",
        aa_muts = "results/aa_muts.json",
        clades = "results/clades.json",
        year = "results/year.json",
        colors = config["files"]["colors"],
        lat_longs = config["files"]["lat_longs"],
        auspice_config = config["files"]["auspice_config"],
        description = config["files"]["description"]
    output:
        auspice_json = "auspice/rabies.json"
    log:
        "logs/export.txt",
    benchmark:
        "benchmarks/export.txt"
    params:
        strain_id = config["strain_id_field"],
    shell:
        """
        augur export v2 \
            --tree {input.tree} \
            --metadata {input.metadata} \
            --metadata-id-columns {params.strain_id} \
            --node-data {input.branch_lengths} {input.nt_muts} {input.aa_muts} {input.year} {input.clades} \
            --colors {input.colors} \
            --lat-longs {input.lat_longs} \
            --auspice-config {input.auspice_config} \
            --include-root-sequence-inline \
            --output {output.auspice_json} \
            --description {input.description} \
            2>&1 | tee {log}
        """

rule tip_frequencies:
    """
    Estimating KDE frequencies for tips
    """
    input:
        tree = "results/tree.nwk",
        metadata = "data/metadata.tsv"
    params:
        strain_id = config["strain_id_field"],
        min_date = config["tip_frequencies"]["min_date"],
        max_date = config["tip_frequencies"]["max_date"],
        narrow_bandwidth = config["tip_frequencies"]["narrow_bandwidth"],
        wide_bandwidth = config["tip_frequencies"]["wide_bandwidth"]
    output:
        tip_freq = "auspice/rabies_tip-frequencies.json"
    shell:
        r"""
        augur frequencies \
            --method kde \
            --tree {input.tree} \
            --metadata {input.metadata} \
            --metadata-id-columns {params.strain_id} \
            --min-date {params.min_date} \
            --max-date {params.max_date} \
            --narrow-bandwidth {params.narrow_bandwidth} \
            --wide-bandwidth {params.wide_bandwidth} \
            --output {output.tip_freq}
        """
