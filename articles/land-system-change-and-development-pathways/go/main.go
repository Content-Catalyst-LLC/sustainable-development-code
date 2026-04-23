package main

import (
	"encoding/csv"
	"fmt"
	"os"
	"strconv"
)

type LandRecord struct {
	TerritoryName                 string
	CountryOrRegion               string
	TerritoryType                 string
	ConversionPressure            float64
	LandDegradation               float64
	FragmentationRisk             float64
	BiodiversityFunctionLoss      float64
	FoodSettlementDependence      float64
	InfrastructureExpansion       float64
	JusticeExposure               float64
	GovernanceCapacity            float64
	RestorationReadiness          float64
}

func parseRecord(row []string) (LandRecord, error) {
	if len(row) != 12 {
		return LandRecord{}, fmt.Errorf("invalid record length")
	}

	values := make([]float64, 9)
	for i, col := range row[3:] {
		value, err := strconv.ParseFloat(col, 64)
		if err != nil {
			return LandRecord{}, err
		}
		values[i] = value
	}

	return LandRecord{
		TerritoryName:            row[0],
		CountryOrRegion:          row[1],
		TerritoryType:            row[2],
		ConversionPressure:       values[0],
		LandDegradation:          values[1],
		FragmentationRisk:        values[2],
		BiodiversityFunctionLoss: values[3],
		FoodSettlementDependence: values[4],
		InfrastructureExpansion:  values[5],
		JusticeExposure:          values[6],
		GovernanceCapacity:       values[7],
		RestorationReadiness:     values[8],
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

func constrainedLandPathwayRiskScore(record LandRecord) float64 {
	territorialStress := 0.22*record.ConversionPressure +
		0.22*record.LandDegradation +
		0.18*record.FragmentationRisk +
		0.18*record.BiodiversityFunctionLoss +
		0.20*record.InfrastructureExpansion

	developmentDependence := 0.55*record.FoodSettlementDependence +
		0.25*record.JusticeExposure +
		0.20*record.BiodiversityFunctionLoss

	governance := 0.55*record.GovernanceCapacity +
		0.45*record.RestorationReadiness

	score := 0.40*territorialStress +
		0.25*developmentDependence +
		0.20*record.JusticeExposure +
		0.15*(1-governance)

	return clamp01(score)
}

func main() {
	file, err := os.Open("land_system_change_panel.csv")
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

		score := constrainedLandPathwayRiskScore(record)
		fmt.Printf(
			"territory_name=%s territory_type=%s constrained_land_pathway_risk_score=%.3f\n",
			record.TerritoryName, record.TerritoryType, score,
		)
	}
}
