typedef enum {
    JBSPWStatusCouldNotElevate = 1,
    JBSPWStatusInvalidPassword,
    JBSPWStatusNoUser,
    JBSPWStatusInvalidUser,
    JBSPWStatusCouldNotReadFile,
    JBSPWStatusCouldNotFindUser,
    JBSPWStatusFailedToEncrypt,
    JBSPWStatusInvalidFileFormat,
    JBSPWStatusCouldNotWritePassword
} JBSPWStatus;