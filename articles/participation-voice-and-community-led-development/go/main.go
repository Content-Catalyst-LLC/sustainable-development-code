package main

import (
	"encoding/csv"
	"fmt"
	"os"
	"strconv"
)

type ParticipationRecord struct {
	Country                  string
	Region                   string
	ProgramDomain            string
	ParticipatoryDepth       float64
	VoiceEffectiveness       float64
	RepresentationQuality    float64
	InstitutionalUptake      float64
	CommunityControl         float64
	AccountabilityChannel    float64
	LocalKnowledgeIntegration float64
	TrustSupport             float64
	TokenismRisk             float64
}

func parseRecord(row []string) (ParticipationRecord, error) {
	if len(row) != 12 {
		return ParticipationRecord{}, fmt.Errorf("invalid record length")
	}

	values := make([]float64, 9)
	for i, col := range row[3:] {
		value, err := strconv.ParseFloat(col, 64)
		if err != nil {
			return ParticipationRecord{}, err
		}
		values[i] = value
	}

	return ParticipationRecord{
		Country:                  row[0],
		Region:                   row[1],
		ProgramDomain:            row[2],
		ParticipatoryDepth:       values[0],
		VoiceEffectiveness:       values[1],
		RepresentationQuality:    values[2],
		InstitutionalUptake:      values[3],
		CommunityControl:         values[4],
		AccountabilityChannel:    values[5],
		LocalKnowledgeIntegration: values[6],
		TrustSupport:             values[7],
		TokenismRisk:             values[8],
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

func constrainedParticipationScore(record ParticipationRecord) float64 {
	legitimacy := 0.22*record.ParticipatoryDepth +
		0.20*record.VoiceEffectiveness +
		0.20*record.RepresentationQuality +
		0.18*record.InstitutionalUptake +
		0.20*record.TrustSupport

	cld := 0.30*record.CommunityControl +
		0.20*record.LocalKnowledgeIntegration +
		0.20*record.InstitutionalUptake +
		0.15*record.AccountabilityChannel +
		0.15*record.RepresentationQuality

	score := 0.40*legitimacy +
		0.35*cld +
		0.15*record.AccountabilityChannel +
		0.10*(1-record.TokenismRisk)

	return clamp01(score)
}

func main() {
	file, err := os.Open("participation_and_cld_panel.csv")
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

		score := constrainedParticipationScore(record)
		fmt.Printf(
			"country=%s program_domain=%s constrained_participation_score=%.3f\n",
			record.Country, record.ProgramDomain, score,
		)
	}
}
