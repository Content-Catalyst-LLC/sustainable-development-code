package main

import (
	"encoding/csv"
	"fmt"
	"os"
	"strconv"
)

type InstitutionRecord struct {
	Country                     string
	Region                      string
	InstitutionalDomain         string
	ImplementationCapacity      float64
	CoordinationCapacity        float64
	TrustSupport                float64
	AccountabilityStrength      float64
	DeliveryReliability         float64
	LearningCapacity            float64
	LegalAdministrativeClarity  float64
	FragmentationRisk           float64
	CaptureRisk                 float64
}

func parseRecord(row []string) (InstitutionRecord, error) {
	if len(row) != 12 {
		return InstitutionRecord{}, fmt.Errorf("invalid record length")
	}

	values := make([]float64, 9)
	for i, col := range row[3:] {
		value, err := strconv.ParseFloat(col, 64)
		if err != nil {
			return InstitutionRecord{}, err
		}
		values[i] = value
	}

	return InstitutionRecord{
		Country:                    row[0],
		Region:                     row[1],
		InstitutionalDomain:        row[2],
		ImplementationCapacity:     values[0],
		CoordinationCapacity:       values[1],
		TrustSupport:               values[2],
		AccountabilityStrength:     values[3],
		DeliveryReliability:        values[4],
		LearningCapacity:           values[5],
		LegalAdministrativeClarity: values[6],
		FragmentationRisk:          values[7],
		CaptureRisk:                values[8],
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

func constrainedInstitutionalCapacityScore(record InstitutionRecord) float64 {
	effectiveness := 0.20*record.ImplementationCapacity +
		0.16*record.CoordinationCapacity +
		0.14*record.DeliveryReliability +
		0.14*record.AccountabilityStrength +
		0.12*record.LearningCapacity +
		0.12*record.LegalAdministrativeClarity +
		0.12*record.TrustSupport

	fragility := 0.45*record.FragmentationRisk +
		0.35*record.CaptureRisk +
		0.20*(1-record.TrustSupport)

	score := 0.65*effectiveness +
		0.15*record.ImplementationCapacity +
		0.10*record.LearningCapacity +
		0.10*(1-fragility)

	return clamp01(score)
}

func main() {
	file, err := os.Open("institutions_development_panel.csv")
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

		score := constrainedInstitutionalCapacityScore(record)
		fmt.Printf(
			"country=%s institutional_domain=%s constrained_institutional_capacity_score=%.3f\n",
			record.Country, record.InstitutionalDomain, score,
		)
	}
}
