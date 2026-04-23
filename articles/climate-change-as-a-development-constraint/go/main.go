package main

import (
	"encoding/csv"
	"fmt"
	"os"
	"strconv"
)

type ClimateRecord struct {
	TerritoryName             string
	CountryOrRegion           string
	TerritoryType             string
	HeatStress                float64
	HydrologicalDisruption    float64
	FoodLivelihoodExposure    float64
	HealthBurden              float64
	InfrastructureVulnerability float64
	JusticeExposure           float64
	GovernanceCapacity        float64
	ResilienceReadiness       float64
	DisasterRecurrence        float64
}

func parseRecord(row []string) (ClimateRecord, error) {
	if len(row) != 12 {
		return ClimateRecord{}, fmt.Errorf("invalid record length")
	}

	values := make([]float64, 9)
	for i, col := range row[3:] {
		value, err := strconv.ParseFloat(col, 64)
		if err != nil {
			return ClimateRecord{}, err
		}
		values[i] = value
	}

	return ClimateRecord{
		TerritoryName:              row[0],
		CountryOrRegion:            row[1],
		TerritoryType:              row[2],
		HeatStress:                 values[0],
		HydrologicalDisruption:     values[1],
		FoodLivelihoodExposure:     values[2],
		HealthBurden:               values[3],
		InfrastructureVulnerability: values[4],
		JusticeExposure:            values[5],
		GovernanceCapacity:         values[6],
		ResilienceReadiness:        values[7],
		DisasterRecurrence:         values[8],
	}, nil
}

func clamp01(x float64) float64 {
	if x < 0 {
		return 0
	}
	if x > 1 {
		return 1
	}
	return x
}

func constrainedClimateDevelopmentScore(record ClimateRecord) float64 {
	climateStress := 0.20*record.HeatStress +
		0.18*record.HydrologicalDisruption +
		0.18*record.DisasterRecurrence +
		0.22*record.InfrastructureVulnerability +
		0.22*record.HealthBurden

	developmentExposure := 0.40*record.FoodLivelihoodExposure +
		0.25*record.JusticeExposure +
		0.20*record.HealthBurden +
		0.15*record.InfrastructureVulnerability

	governance := 0.55*record.GovernanceCapacity +
		0.45*record.ResilienceReadiness

	score := 0.42*climateStress +
		0.28*developmentExposure +
		0.15*record.JusticeExposure +
		0.15*(1-governance)

	return clamp01(score)
}

func main() {
	file, err := os.Open("climate_constraint_panel.csv")
	if err != nil {
		fmt.Println("Error opening CSV:", err)
		return
	}
	defer file.Close()

	reader := csv.NewReader(file)
	rows, err := reader.ReadAll()
	if err != nil {
		fmt.Println("Error reading CSV:", err)
		return
	}

	for i, row := range rows {
		if i == 0 {
			continue
		}

		record, err := parseRecord(row)
		if err != nil {
			fmt.Println("Parse error:", err)
			continue
		}

		score := constrainedClimateDevelopmentScore(record)
		fmt.Printf(
			"territory_name=%s territory_type=%s constrained_climate_development_score=%.3f\n",
			record.TerritoryName, record.TerritoryType, score,
		)
	}
}
