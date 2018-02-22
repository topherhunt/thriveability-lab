if Rails.env.development?
  `echo '' > log/development.log`
end

if Rails.env.test?
  `echo '' > log/test.log`
end
