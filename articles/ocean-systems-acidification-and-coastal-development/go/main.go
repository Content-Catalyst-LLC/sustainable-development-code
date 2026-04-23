package main

import (
	"encoding/csv"
	"fmt"
	"os"
	"strconv"
)

type CoastalRecord struct {
	CoastalSystemName             string
	CountryOrRegion               string
	CoastalType                   string
	AcidificationPressure         float64
	WarmingPressure               float64
	DeoxygenationPressure         float64
	MarineDependence              float64
	FisheriesLivelihoodDependence float64
	CoastalInfrastructureExposure float64
	GovernanceCapacity            float64
	JusticeExposure               float64
	MonitoringReadiness           float64
}

func parseRecord(row []string) (CoastalRecord, error) {
	if len(row) != 12 {
		return CoastalRecord{}, fmt.Errorf("invalid record length")
	}

	values := make([]float64, 9)
	for i, col := range row[3:] {
		value, err := strconv.ParseFloat(col, 64)
		if err != nil {
			return CoastalRecord{}, err
		}
		values[i] = value
	}

	return CoastalRecord{
		CoastalSystemName:             row[0],
		CountryOrRegion:               row[1],
		CoastalType:                   row[2],
		AcidificationPressure:         values[0],
		WarmingPressure:               values[1],
		DeoxygenationPressure:         values[2],
		MarineDependence:              values[3],
		FisheriesLivelihoodDependence: values[4],
		CoastalInfrastructureExposure: values[5],
		GovernanceCapacity:            values[6],
		JusticeExposure:               values[7],
		MonitoringReadiness:           values[8],
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

func constrainedCoastalOceanRiskScore(record CoastalRecord) float64 {
	habitability := 0.36*record.AcidificationPressure +
		0.32*record.WarmingPressure +
		0.32*record.DeoxygenationPressure

	dependence := 0.40*record.MarineDependence +
		0.35*record.FisheriesLivelihoodDependence +
		0.25*record.CoastalInfrastructureExposure

	governance := 0.55*record.GovernanceCapacity +
		0.45*record.MonitoringReadiness

	score := 0.40*habitability +
		0.30*dependence +
		0.20*record.JusticeExposure +
		0.10*(1-governance)

	return clamp01(score)
}

func main() {
	file, err := os.Open("ocean_acidification_coastal_panel.csv")
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

		score := constrainedCoastalOceanRiskScore(record)
		fmt.Printf(
			"coastal_system_name=%s coastal_type=%s constrained_coastal_ocean_risk_score=%.3f\n",
			record.CoastalSystemName, record.CoastalType, score,
		)
	}
}
