part of 'organization_cubit.dart';

class OrganizationState extends Equatable {
  const OrganizationState({
    this.organization,
    this.confirmations,
    this.userOrganizationTicketToken,
    this.isLoading = true,
  });

  final Organization? organization;
  final List<Confirmation>? confirmations;
  final String? userOrganizationTicketToken;
  final bool isLoading;

  OrganizationState copyWith({
    Organization? organization,
    List<Confirmation>? confirmations,
    String? userOrganizationTicketToken,
    bool? isLoading,
  }) {
    return OrganizationState(
      organization: organization ?? this.organization,
      confirmations: confirmations ?? this.confirmations,
      isLoading: isLoading ?? this.isLoading,
      userOrganizationTicketToken:
          userOrganizationTicketToken ?? this.userOrganizationTicketToken,
    );
  }

  @override
  List<Object?> get props =>
      [organization, confirmations, userOrganizationTicketToken, isLoading];
}
