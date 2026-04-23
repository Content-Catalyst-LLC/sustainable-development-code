package main

import (
	"encoding/csv"
	"fmt"
	"os"
	"strconv"
)

type BiosphereRecord struct {
	TerritoryName                string
	CountryOrRegion              string
	TerritoryType                string
	EcosystemDegradation         float64
	FragmentationRisk            float64
	EcologicalServiceErosion     float64
	FoodWaterHealthDependence    float64
	LivelihoodEcologicalDependence float64
	JusticeExposure              float64
	GovernanceCapacity           float64
	RestorationReadiness         float64
	BiosphereFunctionLoss        float64
}

func parseRecord(row []string) (BiosphereRecord, error) {
	if len(row) != 12 {
		return BiosphereRecord{}, fmt.Errorf("invalid record length")
	}

	values := make([]float64, 9)
	for i, col := range row[3:] {
		value, err := strconv.ParseFloat(col, 64)
		if err != nil {
			return BiosphereRecord{}, err
		}
		values[i] = value
	}

	return BiosphereRecord{
		TerritoryName:                 row[0],
		CountryOrRegion:               row[1],
		TerritoryType:                 row[2],
		EcosystemDegradation:          values[0],
		FragmentationRisk:             values[1],
		EcologicalServiceErosion:      values[2],
		FoodWaterHealthDependence:     values[3],
		LivelihoodEcologicalDependence: values[4],
		JusticeExposure:               values[5],
		GovernanceCapacity:            values[6],
		RestorationReadiness:          values[7],
		BiosphereFunctionLoss:         values[8],
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

func constrainedBiosphereDevelopmentScore(record BiosphereRecord) float64 {
	biosphereStress := 0.24*record.EcosystemDegradation +
		0.18*record.FragmentationRisk +
		0.20*record.EcologicalServiceErosion +
		0.20*record.BiosphereFunctionLoss +
		0.18*record.JusticeExposure

	developmentDependence := 0.50*record.FoodWaterHealthDependence +
		0.30*record.LivelihoodEcologicalDependence +
		0.20*record.EcologicalServiceErosion

	governance := 0.55*record.GovernanceCapacity +
		0.45*record.RestorationReadiness

	score := 0.42*biosphereStress +
		0.28*developmentDependence +
		0.15*record.JusticeExposure +
		0.15*(1-governance)

	return clamp01(score)
}

func main() {
	file, err := os.Open("biosphere_integrity_panel.csv")
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

		score := constrainedBiosphereDevelopmentScore(record)
		fmt.Printf(
			"territory_name=%s territory_type=%s constrained_biosphere_development_score=%.3f\n",
			record.TerritoryName, record.TerritoryType, score,
		)
	}
}
