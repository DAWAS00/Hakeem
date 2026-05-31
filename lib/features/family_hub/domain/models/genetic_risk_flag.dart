enum RiskLevel { low, moderate, high }

class GeneticRiskFlag {
  const GeneticRiskFlag({
    required this.condition,
    required this.riskLevel,
    required this.affectedRelativesCount,
    required this.explanationAr,
    required this.recommendationAr,
  });

  final String condition;
  final RiskLevel riskLevel;
  final int affectedRelativesCount;
  final String explanationAr;
  final String recommendationAr;
}
