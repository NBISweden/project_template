configfile: "config.yml"

rule all:
    """Convert README.md to upper case"""
    input:
        "code/README.md"
    output:
        "scratch/README.upper.md"
    params:
        msg = config["msg_to_print"]
    shell:
        "echo {params.msg} && tr [a-z] [A-Z] < {input} > {output}"
