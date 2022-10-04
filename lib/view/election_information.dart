import 'package:elections_dapp/bloc/election_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ElectionInformation extends StatefulWidget {
  final String electionName;
  const ElectionInformation({Key? key, required this.electionName})
      : super(key: key);

  @override
  State<ElectionInformation> createState() => _ElectionInformationState();
}

class _ElectionInformationState extends State<ElectionInformation> {
  @override
  Widget build(BuildContext context) {
    const labelTextStyle = TextStyle(fontSize: 20.0);
    const valueTextStyle = TextStyle(fontSize: 40.0);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.electionName),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              key: const Key('electionInfo_candidateVotes'),
              children: [
                Column(
                  children: const [
                    Text('Total Candidates', style: labelTextStyle),
                    Text('0', style: valueTextStyle),
                  ],
                ),
                Column(
                  children: const [
                    Text('Total Votes', style: labelTextStyle),
                    Text('0', style: valueTextStyle),
                  ],
                ),
              ],
            ),
            const ElectionInputsWidget(),
          ],
        ),
      ),
    );
  }
}

class ElectionInputsWidget extends StatefulWidget {
  const ElectionInputsWidget({Key? key}) : super(key: key);

  @override
  State<ElectionInputsWidget> createState() => _ElectionInputsWidgetState();
}

class _ElectionInputsWidgetState extends State<ElectionInputsWidget> {
  late TextEditingController addCandidateController;
  late TextEditingController addVoteController;

  @override
  void initState() {
    addCandidateController = TextEditingController();
    addVoteController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    addCandidateController.dispose();
    addVoteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ElectionBloc, ElectionState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 24.0),
          child: Column(
            children: [
              Column(
                children: [
                  TextField(
                    controller: addCandidateController,
                    decoration: const InputDecoration(
                        filled: true, hintText: 'Enter candidate name'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (addCandidateController.text.isNotEmpty) {
                            context.read<ElectionBloc>().add(
                                  AddCandidatePressed(
                                      candidateName:
                                          addCandidateController.text),
                                );
                          }
                        },
                        child: state is AddCandidateInProgress
                            ? const CircularProgressIndicator()
                            : const Text('Add Candidate'),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40.0),
              Column(
                children: [
                  TextField(
                    controller: addVoteController,
                    decoration: const InputDecoration(
                        filled: true, hintText: 'Enter voter address'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (addVoteController.text.isNotEmpty) {
                            context.read<ElectionBloc>().add(
                                  AuthorizedVoterPressed(
                                      voterAddress: addVoteController.text),
                                );
                          }
                        },
                        child: state is AuthorizeVoterInProgress
                            ? const CircularProgressIndicator()
                            : const Text('Authorize Voter'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
