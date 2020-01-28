json.anexos(@anexos) do |anexo|
  json.identifier anexo.file.identifier
  json.url anexo.url
end
