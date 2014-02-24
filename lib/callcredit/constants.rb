module Callcredit
  module Constants
    # Check types suported by the CallValidate API
    CHECKS = %w(BankStandard BankEnhanced CardLive CardEnhanced IDEnhanced
                NCOAAlert CallValidate3D TheAffordabilityReport DeliveryFraud
                EmailValidate CreditScore Zodiac IPCountry)

    INDIVIDUAL_DETAILS = {
      date_of_birth:            "Dateofbirth",
      title:                    "Title",
      first_name:               "Firstname",
      last_name:                "Surname",
      middle_names:             "Othernames",
      phone:                    "Phonenumber",
      email:                    "Emailaddress",
      moved_recently?:          "addresslessthan12months",
      passport_line_1:          "Passportline1",
      passport_line_2:          "Passportline2",
      driving_license:          "Drivinglicensenumber",
      passport_expiry:          "PassportExpiryDate",
      ip:                       "IPAddress"
    }

    ADDRESS_DETAILS = {
      abode_number:             "Abodenumber",
      building_number:          "Buildingnumber",
      building_name:            "Buildingname",
      address_line_1:           "Address1",
      address_line_2:           "Address2",
      address_line_3:           "Address3",
      town:                     "Town",
      postcode:                 "Postcode",
      previous_abode_number:    "Previousabodenumber",
      previous_building_number: "Previousbuildingnumber",
      previous_building_name:   "Previousbuildingname",
      previous_address_line_1:  "Previousaddress1",
      previous_address_line_2:  "Previousaddress2",
      previous_address_line_3:  "Previousaddress3",
      previous_town:            "Previoustown",
      previous_postcode:        "Previouspostcode",
      delivery_abode_number:    "Deliveryabodenumber",
      delivery_building_number: "Deliverybuildingnumber",
      delivery_building_name:   "Deliverybuildingname",
      delivery_address_line_1:  "Deliveryaddress1",
      delivery_address_line_2:  "Deliveryaddress2",
      delivery_address_line_3:  "Deliveryaddress3",
      delivery_town:            "Deliverytown",
      delivery_postcode:        "Deliverypostcode"
    }
  end
end