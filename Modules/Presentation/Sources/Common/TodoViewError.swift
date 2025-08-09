import Foundation

public enum TodoViewError: LocalizedError {
    case failedToLoad
    case failedToCreate
    case failedToUpdate
    case failedToDelete
    case unknown
    
    public var errorDescription: String? {
        switch self {
        case .failedToLoad:
            return "할 일 목록을 불러오는데 실패했습니다."
        case .failedToCreate:
            return "할 일 생성에 실패했습니다."
        case .failedToUpdate:
            return "할 일 수정에 실패했습니다."
        case .failedToDelete:
            return "할 일 삭제에 실패했습니다."
        case .unknown:
            return "알 수 없는 오류가 발생했습니다."
        }
    }
}
