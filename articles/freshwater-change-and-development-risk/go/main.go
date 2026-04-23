package main

import (
	"encoding/csv"
	"fmt"
	"os"
	"strconv"
)

type FreshwaterRecord struct {
	TerritoryName               string
	CountryOrRegion             string
	TerritoryType               string
	StreamflowStress            float64
	SoilMoistureStress          float64
	WaterQualityBurden          float64
	WastewaterTreatmentDeficit  float64
	FreshwaterEcosystemDecline  float64
	FoodLivelihoodDependence    float64
	HealthSanitationExposure    float64
	GovernanceCapacity          float64
	MonitoringReadiness         float64
}

func parseRecord(row []string) (FreshwaterRecord, error) {
	if len(row) != 12 {
		return FreshwaterRecord{}, fmt.Errorf("invalid record length")
	}

	values := make([]float64, 9)
	for i, col := range row[3:] {
		value, err := strconv.ParseFloat(col, 64)
		if err != nil {
			return FreshwaterRecord{}, err
		}
		values[i] = value
	}

	return FreshwaterRecord{
		TerritoryName:              row[0],
		CountryOrRegion:            row[1],
		TerritoryType:              row[2],
		StreamflowStress:           values[0],
		SoilMoistureStress:         values[1],
		WaterQualityBurden:         values[2],
		WastewaterTreatmentDeficit: values[3],
		FreshwaterEcosystemDecline: values[4],
		FoodLivelihoodDependence:   values[5],
		HealthSanitationExposure:   values[6],
		GovernanceCapacity:         values[7],
		MonitoringReadiness:        values[8],
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

func constrainedFreshwaterRiskScore(record FreshwaterRecord) float64 {
	hydrologicalStress := 0.22*record.StreamflowStress +
		0.20*record.SoilMoistureStress +
		0.18*record.WaterQualityBurden +
		0.20*record.WastewaterTreatmentDeficit +
		0.20*record.FreshwaterEcosystemDecline

	developmentExposure := 0.45*record.FoodLivelihoodDependence +
		0.35*record.HealthSanitationExposure +
		0.20*record.WaterQualityBurden

	governance := 0.55*record.GovernanceCapacity +
		0.45*record.MonitoringReadiness

	score := 0.42*hydrologicalStress +
		0.28*developmentExposure +
		0.15*record.HealthSanitationExposure +
		0.15*(1-governance)

	return clamp01(score)
}

func main() {
	file, err := os.Open("freshwater_change_panel.csv")
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

		score := constrainedFreshwaterRiskScore(record)
		fmt.Printf(
			"territory_name=%s territory_type=%s constrained_freshwater_risk_score=%.3f\n",
			record.TerritoryName, record.TerritoryType, score,
		)
	}
}
