# assume canonical
export tk_tarason
function tk_tarason(canon::CanonicalRecord)::TaraSONRecord
    
    tarason_record = TaraSONRecord(
        JSON.json(canon.data; pretty=true)
    )

    return tarason_record
end