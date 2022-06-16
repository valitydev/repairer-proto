include "proto/base.thrift"
include "proto/domain.thrift"
include "proto/payment_processing.thrift"
include "withdrawal_session.thrift"

namespace java dev.vality.repairer

typedef string ProviderID
typedef string MachineID
typedef string Namespace
typedef string ContinuationToken
typedef list<MachineSimpleRepairRequest> SimpleRepairRequest
typedef list<RepairWithdrawalRequest> RepairWithdrawalsRequest
typedef list<RepairInvoiceRequest> RepairInvoicesRequest
typedef list<MachineRepairResponse> RepairResponse

struct MachineSimpleRepairRequest {
    1: required Namespace ns
    2: required MachineID id
}

struct RepairWithdrawalRequest {
    1: required withdrawal_session.SessionID id
    2: required withdrawal_session.RepairScenario scenario
}

struct RepairInvoiceRequest {
    1: required domain.InvoiceID id
    2: required payment_processing.InvoiceRepairScenario scenario
}

struct MachineRepairResponse {
    1: required Namespace ns
    2: required MachineID id
    3: required RepairStatus status
    4: optional string error_message
}

struct Timespan {
    1: required base.Timestamp from_time
    2: required base.Timestamp to_time
}

enum RepairStatus {
    failed,
    in_progress,
    repaired
}

struct SearchRequest {
    1: optional MachineID id
    2: optional Namespace ns
    3: optional Timespan timespan
    4: optional ProviderID provider_id
    5: optional RepairStatus status
    6: optional string error_message
    7: optional ContinuationToken continuation_token
}

struct Machine {
    1: required MachineID id
    2: required Namespace ns
    3: required base.Timestamp created_at
    4: required RepairStatus status
    5: optional ProviderID provider_id
    6: optional string error_message
    7: optional list<StatusHistory> history
}

struct StatusHistory {
    1: required RepairStatus status
    2: required base.Timestamp changed_at
}

struct SearchResponse {
    1: required list<Machine> machines
    2: optional ContinuationToken continuation_token
}

service RepairManagement {

    RepairResponse SimpleRepairAll (1: SimpleRepairRequest request);

    RepairResponse RepairWithdrawals (1: RepairWithdrawalsRequest request);

    RepairResponse RepairInvoices (1: RepairInvoicesRequest request);

    SearchResponse Search (1: SearchRequest request);
}