local db = dofile("/mail/aliases.lua")

function auth_userdb_lookup(req)
  for domain, users in pairs(db) do
    for user, _ in pairs(users) do
        if req.user == user.."@"..domain then
            return dovecot.auth.USERDB_RESULT_OK, "uid=mail gid=mail"
        end
    end
  end  
  return dovecot.auth.USERDB_RESULT_USER_UKNOWN, "no such user"
end

function auth_passdb_lookup(req)
  for domain, users in pairs(db) do
    for user, info in pairs(users) do
        if req.user == user.."@"..domain and info.pass then
           return dovecot.auth.PASSDB_RESULT_OK, "password="..info.pass
        end
    end
  end
  return dovecot.auth.PASSDB_RESULT_USER_UNKNOWN, "no such user"
end

function auth_passdb_verify(req, password)
  for domain, users in pairs(aliases) do
    for user, info in pairs(users) do
        if req.user == user.."@"..domain and info.pass then
            if password == pass then
                 return dovecot.auth.PASSDB_RESULT_OK, "password="..pass
            else
                 return dovecot.auth.PASSDB_RESULT_PASSWORD_MISMATCH, "wrong password"
            end
        end
    end
  end
  return dovecot.auth.PASSDB_RESULT_USER_UNKNOWN, "no such user"
end

function script_init()
  return 0
end

function script_deinit()
end
