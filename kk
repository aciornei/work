directory:
      enabled: true
      base_dn: "OU=Utilizatori,DC=domeniu,DC=ro"

      user_filter: "(&(objectCategory=person)(objectClass=user)(!(objectClass=computer))(!(userAccountControl:1.2.840.113556.1.4.803:=2)))"

      identity_attribute: "objectGUID"
      department_attribute: "department"
      phone_attribute: "telephoneNumber"

      page_size: 500
      default_department: ""
