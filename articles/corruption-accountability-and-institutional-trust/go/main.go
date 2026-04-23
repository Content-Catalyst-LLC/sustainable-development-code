package main

import (
	"encoding/csv"
	"fmt"
	"os"
	"strconv"
)

type IntegrityRecord struct {
	Country                    string
	Region                     string
	InstitutionalDomain        string
	ProcurementIntegrity       float64
	AccountabilityStrength     float64
	ServiceIntegrity           float64
	BeneficialOwnershipVis     float64
	AuditCapacity              float64
	ComplaintAccess            float64
	TrustSupport               float64
	CaptureRisk                float64
	SelectiveEnforcementRisk   float64
	CorruptionVisibilityGap    float64
}

func parseRecord(row []string) (IntegrityRecord, error) {
	if len(row) != 13 {
		return IntegrityRecord{}, fmt.Errorf("invalid record length")
	}

	values := make([]float64, 10)
	for i, col := range row[3:] {
		value, err := strconv.ParseFloat(col, 64)
		if err != nil {
			return IntegrityRecord{}, err
		}
		values[i] = value
	}

	return IntegrityRecord{
		Country:                  row[0],
		Region:                   row[1],
		InstitutionalDomain:      row[2],
		ProcurementIntegrity:     values[0],
		AccountabilityStrength:   values[1],
		ServiceIntegrity:         values[2],
		BeneficialOwnershipVis:   values[3],
		AuditCapacity:            values[4],
		ComplaintAccess:          values[5],
		TrustSupport:             values[6],
		CaptureRisk:              values[7],
		SelectiveEnforcementRisk: values[8],
		CorruptionVisibilityGap:  values[9],
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

func constrainedIntegrityScore(record IntegrityRecord) float64 {
	integrity := 0.20*record.ProcurementIntegrity +
		0.18*record.AccountabilityStrength +
		0.14*record.ServiceIntegrity +
		0.14*record.BeneficialOwnershipVis +
		0.14*record.AuditCapacity +
		0.10*record.ComplaintAccess +
		0.10*record.TrustSupport

	distortion := 0.30*record.CaptureRisk +
		0.25*record.SelectiveEnforcementRisk +
		0.20*(1-record.ProcurementIntegrity) +
		0.15*(1-record.ServiceIntegrity) +
		0.10*record.CorruptionVisibilityGap

	score := 0.55*integrity +
		0.20*record.AccountabilityStrength +
		0.15*record.TrustSupport +
		0.10*(1-distortion)

	return clamp01(score)
}

func main() {
	file, err := os.Open("corruption_integrity_panel.csv")
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

		score := constrainedIntegrityScore(record)
		fmt.Printf(
			"country=%s institutional_domain=%s constrained_integrity_score=%.3f\n",
			record.Country, record.InstitutionalDomain, score,
		)
	}
}
