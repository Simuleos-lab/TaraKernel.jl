# assume masked canonical
export tk_tarason
function tk_tarason(masked::MaskedCanonicalRecord)::TaraSONRecord
    
    tarason_record = TaraSONRecord(
        JSON.json(masked.data; pretty=true)
    )

    return tarason_record
end