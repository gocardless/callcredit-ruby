module Callcredit
  module Constants
    # Check types suported by the CallValidate API
    CHECKS = %w(BankStandard BankEnhanced CardLive CardEnhanced IDEnhanced
                NCOAAlert CallValidate3D TheAffordabilityReport DeliveryFraud
                EmailValidate CreditScore Zodiac IPCountry)
  end
end