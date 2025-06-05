package org.project.domain;

import lombok.Data;

@Data
public class ChargeVO {
	public int basic;
    public int useCharge;
    public int ceCharge;
    public int fcAdjustment;
    public int sumCharge;
    public int fund;
    public int addedTax;
    public int totalCharge;
}
