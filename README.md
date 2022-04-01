Requirements:
- conda/mamba environment based on dependencies in `environment.yml`
- Java and Maven accessible via command line
- MATSim scenario files in `input/` (e.g. `input/ile_de_france_config.xml`)
- Trips file in `input/` and configured (as well as scenario config) in `config.yml` file

Run (with 4 threads here):
```
snakemake --cores 4 all
```

Output in `data/contacts.csv`

Process:
- Take trips file, convert to routing format
- Download eqasim-java and build jar
- Run routing on the converted file
- Process routing output to find contacts (ID Person A, ID Person B, Vehicle ID, duration of the interaction, start time of the interaction)
