configfile: "config.yml"

rule all:
    """Concatenate inputs"""
    input:
        "foo",
        "bar"
    output:
        "foobar"
    params:
        msg = config["msg_to_print"]
    shell:
        "echo {params.msg} && cat {input[0]} {input[1]} > {output}"
