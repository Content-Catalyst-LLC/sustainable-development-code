.PHONY: run python sql r julia clean

run:
	bash bash/run_all.sh

python:
	python3 python/future_development_scenario_stress_test.py

sql:
	python3 sql/run_sqlite_dashboard.py

r:
	Rscript r/development_viability_panel_summary.R

julia:
	julia julia/threshold_loss_model.jl

clean:
	find outputs -type f ! -name ".gitkeep" -delete
