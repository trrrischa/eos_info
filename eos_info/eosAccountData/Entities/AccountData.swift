//
//  AccountData.swift
//  eos_info
//
//  Created by Ekaterina Nesterova on 03.04.2022.
//

// MARK: - AccountData
struct AccountData: Codable {
    let accountName: String?
    let headBlockNum: Int?
    let headBlockTime: String?
    let privileged: Bool?
    let lastCodeUpdate, created, coreLiquidBalance: String?
    let ramQuota, netWeight: Int?
    let cpuWeight: String?
    let netLimit, cpuLimit: Limit?
    let ramUsage: Int?
    let permissions: [PermissionElement]
    let totalResources: TotalResources?
    let subjectiveCPUBillLimit: Limit?

    enum CodingKeys: String, CodingKey {
        case accountName = "account_name"
        case headBlockNum = "head_block_num"
        case headBlockTime = "head_block_time"
        case privileged
        case lastCodeUpdate = "last_code_update"
        case created
        case coreLiquidBalance = "core_liquid_balance"
        case ramQuota = "ram_quota"
        case netWeight = "net_weight"
        case cpuWeight = "cpu_weight"
        case netLimit = "net_limit"
        case cpuLimit = "cpu_limit"
        case ramUsage = "ram_usage"
        case permissions
        case totalResources = "total_resources"
        case subjectiveCPUBillLimit = "subjective_cpu_bill_limit"
    }
}

// MARK: - Limit
struct Limit: Codable {
    let used, available, max: Int?
}

// MARK: - PermissionElement
struct PermissionElement: Codable {
    let permName, parent: String?
    let requiredAuth: RequiredAuth?

    enum CodingKeys: String, CodingKey {
        case permName = "perm_name"
        case parent
        case requiredAuth = "required_auth"
    }
}

// MARK: - RequiredAuth
struct RequiredAuth: Codable {
    let threshold: Int?
    let keys: [Key]
    let accounts: [Account]
}

// MARK: - Account
struct Account: Codable {
    let permission: AccountPermission?
    let weight: Int?
}

// MARK: - AccountPermission
struct AccountPermission: Codable {
    let actor, permission: String?
}

// MARK: - Key
struct Key: Codable {
    let key: String?
    let weight: Int?
}

// MARK: - TotalResources
struct TotalResources: Codable {
    let owner, netWeight, cpuWeight: String?
    let ramBytes: Int?

    enum CodingKeys: String, CodingKey {
        case owner
        case netWeight = "net_weight"
        case cpuWeight = "cpu_weight"
        case ramBytes = "ram_bytes"
    }
}
