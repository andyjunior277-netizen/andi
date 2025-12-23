import 'dart:collection';

import '../models/donor_submission.dart';

class DonorRepository {
  DonorRepository._internal();
  static final DonorRepository _instance = DonorRepository._internal();
  factory DonorRepository() => _instance;

  final List<DonorSubmission> _submissions = <DonorSubmission>[];

  // key: hospitalName, value: map bloodType -> units
  final Map<String, Map<String, int>> _hospitalStocks = <String, Map<String, int>>{};

  UnmodifiableListView<DonorSubmission> get submissions => UnmodifiableListView(_submissions);

  Map<String, Map<String, int>> get hospitalStocks => _hospitalStocks;

  // Method untuk mendapatkan submissions berdasarkan rumah sakit
  List<DonorSubmission> getSubmissionsByHospital(String hospitalName) {
    return _submissions.where((submission) => submission.hospital == hospitalName).toList();
  }

  // Method untuk mendapatkan stok berdasarkan rumah sakit
  Map<String, int> getStocksByHospital(String hospitalName) {
    return _hospitalStocks[hospitalName] ?? <String, int>{};
  }

  void addSubmission(DonorSubmission submission) {
    _submissions.add(submission);
  }

  void removeSubmission(DonorSubmission submission) {
    _submissions.remove(submission);
  }

  void addStockFromSubmission(DonorSubmission submission, int units) {
    addStock(
      hospital: submission.hospital,
      bloodType: submission.bloodType,
      units: units,
    );
    removeSubmission(submission);
  }

  void addStock({required String hospital, required String bloodType, required int units}) {
    final Map<String, int> stocksForHospital = _hospitalStocks[hospital] ?? <String, int>{};
    final int current = stocksForHospital[bloodType] ?? 0;
    stocksForHospital[bloodType] = current + units;
    _hospitalStocks[hospital] = stocksForHospital;
  }

  void updateStock({required String hospital, required String bloodType, required int units}) {
    final Map<String, int> stocksForHospital = _hospitalStocks[hospital] ?? <String, int>{};
    if (units == 0) {
      stocksForHospital.remove(bloodType);
    } else {
      stocksForHospital[bloodType] = units;
    }
    
    if (stocksForHospital.isEmpty) {
      _hospitalStocks.remove(hospital);
    } else {
      _hospitalStocks[hospital] = stocksForHospital;
    }
  }
}



