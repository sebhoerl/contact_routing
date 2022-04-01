configfile: "config.yml"

rule eqasim:
    output: "data/routing.jar"
    shell: """
        rm -rf data/eqasim-java
        git clone https://github.com/eqasim-org/eqasim-java data/eqasim-java
        cd data/eqasim-java
        git checkout 9985e6a
        mvn package -Pstandalone --projects ile_de_france --also-make -DskipTests=true
        cp ile_de_france/target/ile_de_france-1.3.1.jar ../routing.jar
    """

rule convert_trips:
    input: config["trips_path"]
    output: "data/routing_input.csv"
    notebook: "notebooks/ConvertTrips.ipynb"

rule routing:
    input: "data/routing_input.csv", "data/routing.jar"
    output: "data/routing_output.csv", "data/routing_output_legs.csv"
    threads: 4
    shell: """
        java -Xmx{config[memory]} -cp data/routing.jar org.eqasim.core.tools.routing.RunBatchPublicTransportRouter --config-path {config[config_path]} --input-path data/routing_input.csv --output-path data/routing_output.csv --threads {threads} --output-legs-path data/routing_output_legs.csv
    """

rule contacts:
    input: "data/routing_output_legs.csv"
    output: "data/contacts.csv"
    notebook: "notebooks/FindContacts.ipynb"

rule all:
    input: "data/contacts.csv"
