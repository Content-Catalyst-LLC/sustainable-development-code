package main

import (
	"encoding/csv"
	"fmt"
	"os"
	"strconv"
)

type TransferRecord struct {
	Country                    string
	Sector                     string
	InfrastructureReadiness    float64
	SkillsCapacity             float64
	InstitutionalCapacity      float64
	SupplierDepth              float64
	FinanceAccess              float64
	StandardsCapacity          float64
	TechnologyAccess           float64
	DependencyRisk             float64
}

func parseRecord(row []string) (TransferRecord, error) {
	if len(row) != 10 {
		return TransferRecord{}, fmt.Errorf("invalid record length")
	}

	values := make([]float64, 8)
	for i, col := range row[2:] {
		value, err := strconv.ParseFloat(col, 64)
		if err != nil {
			return TransferRecord{}, err
		}
		values[i] = value
	}

	return TransferRecord{
		Country:                 row[0],
		Sector:                  row[1],
		InfrastructureReadiness: values[0],
		SkillsCapacity:          values[1],
		InstitutionalCapacity:   values[2],
		SupplierDepth:           values[3],
		FinanceAccess:           values[4],
		StandardsCapacity:       values[5],
		TechnologyAccess:        values[6],
		DependencyRisk:          values[7],
	}, nil
}

func readinessScore(record TransferRecord) float64 {
	absorptive := 0.20*record.SkillsCapacity +
		0.20*record.InstitutionalCapacity +
		0.15*record.SupplierDepth +
		0.15*record.StandardsCapacity +
		0.15*record.InfrastructureReadiness +
		0.15*record.FinanceAccess

	return 0.35*record.TechnologyAccess + 0.45*absorptive - 0.20*record.DependencyRisk
}

func main() {
	file, err := os.Open("technology_transfer_capability_data.csv")
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

		score := readinessScore(record)
		fmt.Printf("country=%s sector=%s readiness_score=%.3f\n",
			record.Country, record.Sector, score)
	}
}
