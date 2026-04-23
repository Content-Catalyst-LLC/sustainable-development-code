package main

import (
	"encoding/csv"
	"fmt"
	"os"
	"strconv"
)

type ThresholdRecord struct {
	SystemName                string
	CountryOrRegion           string
	EcosystemType             string
	CumulativePressure        float64
	SlowVariableDeterioration float64
	FeedbackIntensity         float64
	CascadeExposure           float64
	ResilienceBuffer          float64
	RecoveryDifficulty        float64
	MonitoringReadiness       float64
	PrecautionCapacity        float64
	JusticeExposure           float64
}

func parseRecord(row []string) (ThresholdRecord, error) {
	if len(row) != 12 {
		return ThresholdRecord{}, fmt.Errorf("invalid record length")
	}

	values := make([]float64, 9)
	for i, col := range row[3:] {
		value, err := strconv.ParseFloat(col, 64)
		if err != nil {
			return ThresholdRecord{}, err
		}
		values[i] = value
	}

	return ThresholdRecord{
		SystemName:                row[0],
		CountryOrRegion:           row[1],
		EcosystemType:             row[2],
		CumulativePressure:        values[0],
		SlowVariableDeterioration: values[1],
		FeedbackIntensity:         values[2],
		CascadeExposure:           values[3],
		ResilienceBuffer:          values[4],
		RecoveryDifficulty:        values[5],
		MonitoringReadiness:       values[6],
		PrecautionCapacity:        values[7],
		JusticeExposure:           values[8],
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

func constrainedThresholdRiskScore(record ThresholdRecord) float64 {
	thresholdSensitivity := 0.24*record.CumulativePressure +
		0.18*record.SlowVariableDeterioration +
		0.20*record.FeedbackIntensity +
		0.18*record.RecoveryDifficulty +
		0.20*(1-record.ResilienceBuffer)

	systemicCascade := 0.40*record.CascadeExposure +
		0.20*record.FeedbackIntensity +
		0.20*record.JusticeExposure +
		0.20*record.CumulativePressure

	governanceReadiness := 0.45*record.MonitoringReadiness +
		0.35*record.PrecautionCapacity +
		0.20*record.ResilienceBuffer

	score := 0.45*thresholdSensitivity +
		0.30*systemicCascade +
		0.15*record.JusticeExposure +
		0.10*(1-governanceReadiness)

	return clamp01(score)
}

func main() {
	file, err := os.Open("ecological_thresholds_panel.csv")
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

		score := constrainedThresholdRiskScore(record)
		fmt.Printf(
			"system_name=%s ecosystem_type=%s constrained_threshold_risk_score=%.3f\n",
			record.SystemName, record.EcosystemType, score,
		)
	}
}
