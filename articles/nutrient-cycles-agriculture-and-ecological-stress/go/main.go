package main

import (
	"encoding/csv"
	"fmt"
	"os"
	"strconv"
)

type NutrientRecord struct {
	TerritoryName            string
	CountryOrRegion          string
	TerritoryType            string
	NitrogenSurplus          float64
	PhosphorusSurplus        float64
	RunoffLeakage            float64
	EutrophicationExposure   float64
	SoilBalanceStress        float64
	FoodSystemDependence     float64
	GovernanceCapacity       float64
	MonitoringReadiness      float64
	WaterQualityBurden       float64
}

func parseRecord(row []string) (NutrientRecord, error) {
	if len(row) != 12 {
		return NutrientRecord{}, fmt.Errorf("invalid record length")
	}

	values := make([]float64, 9)
	for i, col := range row[3:] {
		value, err := strconv.ParseFloat(col, 64)
		if err != nil {
			return NutrientRecord{}, err
		}
		values[i] = value
	}

	return NutrientRecord{
		TerritoryName:          row[0],
		CountryOrRegion:        row[1],
		TerritoryType:          row[2],
		NitrogenSurplus:        values[0],
		PhosphorusSurplus:      values[1],
		RunoffLeakage:          values[2],
		EutrophicationExposure: values[3],
		SoilBalanceStress:      values[4],
		FoodSystemDependence:   values[5],
		GovernanceCapacity:     values[6],
		MonitoringReadiness:    values[7],
		WaterQualityBurden:     values[8],
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

func constrainedNutrientStressScore(record NutrientRecord) float64 {
	biogeochemicalStress := 0.24*record.NitrogenSurplus +
		0.22*record.PhosphorusSurplus +
		0.20*record.RunoffLeakage +
		0.18*record.SoilBalanceStress +
		0.16*record.WaterQualityBurden

	developmentDependence := 0.50*record.FoodSystemDependence +
		0.30*record.EutrophicationExposure +
		0.20*record.WaterQualityBurden

	governance := 0.55*record.GovernanceCapacity +
		0.45*record.MonitoringReadiness

	score := 0.42*biogeochemicalStress +
		0.28*developmentDependence +
		0.15*record.EutrophicationExposure +
		0.15*(1-governance)

	return clamp01(score)
}

func main() {
	file, err := os.Open("nutrient_cycles_agriculture_panel.csv")
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

		score := constrainedNutrientStressScore(record)
		fmt.Printf(
			"territory_name=%s territory_type=%s constrained_nutrient_stress_score=%.3f\n",
			record.TerritoryName, record.TerritoryType, score,
		)
	}
}
