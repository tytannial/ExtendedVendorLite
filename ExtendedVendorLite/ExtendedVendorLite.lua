--------------------------------
-- Credit: Extended Vendor UI
--------------------------------

local VendorAddon = LibStub("AceAddon-3.0"):NewAddon("ExtendedVendorLite", "AceEvent-3.0")

-- 默认每页显示物品数量
local OLD_MERCHANT_ITEMS_PER_PAGE = 10
-- 拓展每页显示物品数量
local NEW_MERCHANT_ITEMS_PER_PAGE = 20

function VendorAddon:UpdateMerchantPositions()
	for i = 1, _G.MERCHANT_ITEMS_PER_PAGE do
		local button = _G["MerchantItem" .. i]
		button:Show()
		button:ClearAllPoints()

		if (i % OLD_MERCHANT_ITEMS_PER_PAGE) == 1 then
			if (i == 1) then
				button:SetPoint("TOPLEFT", _G.MerchantFrame, "TOPLEFT", 24, -70)
			else
				button:SetPoint("TOPLEFT", _G["MerchantItem" .. (i - (OLD_MERCHANT_ITEMS_PER_PAGE - 1))], "TOPRIGHT", 12, 0)
			end
		else
			if (i % 2) == 1 then
				button:SetPoint("TOPLEFT", _G["MerchantItem" .. (i - 2)], "BOTTOMLEFT", 0, -16)
			else
				button:SetPoint("TOPLEFT", _G["MerchantItem" .. (i - 1)], "TOPRIGHT", 12, 0)
			end
		end
	end
end

function VendorAddon:UpdateBuybackPositions()
	for i = 1, _G.MERCHANT_ITEMS_PER_PAGE do
		local button = _G["MerchantItem" .. i]
		button:ClearAllPoints()

		if i > _G.BUYBACK_ITEMS_PER_PAGE then
			button:Hide()
		else
			if i == 1 then
				button:SetPoint("TOPLEFT", _G.MerchantFrame, "TOPLEFT", 64, -105)
			else
				if (i % 3) == 1 then
					button:SetPoint("TOPLEFT", _G["MerchantItem" .. (i - 3)], "BOTTOMLEFT", 0, -30)
				else
					button:SetPoint("TOPLEFT", _G["MerchantItem" .. (i - 1)], "TOPRIGHT", 50, 0)
				end
			end
		end
	end
end

function VendorAddon:OnInitialize()
	_G.MERCHANT_ITEMS_PER_PAGE = NEW_MERCHANT_ITEMS_PER_PAGE
	_G.MerchantFrame:SetWidth(690)

	for i = 1, _G.MERCHANT_ITEMS_PER_PAGE do
		if not _G["MerchantItem" .. i] then
			CreateFrame("Frame", "MerchantItem" .. i, _G.MerchantFrame, "MerchantItemTemplate")
		end
	end
	
	-- 购回物品按钮位置
	_G.MerchantBuyBackItem:ClearAllPoints()
	_G.MerchantBuyBackItem:SetPoint("TOPLEFT", _G.MerchantItem10, "BOTTOMLEFT", -14, -20)
	-- 翻页和页码
	_G.MerchantPrevPageButton:ClearAllPoints()
	_G.MerchantPrevPageButton:SetPoint("CENTER", _G.MerchantFrame, "BOTTOM", 30, 55)
	_G.MerchantPageText:ClearAllPoints()
	_G.MerchantPageText:SetPoint("BOTTOM", _G.MerchantFrame, "BOTTOM", 160, 50)
	_G.MerchantNextPageButton:ClearAllPoints()
	_G.MerchantNextPageButton:SetPoint("CENTER", _G.MerchantFrame, "BOTTOM", 290, 55)
	
	-- 修复沙雕暴雪NPC名字获取函数炸了
	local _, _, _, buildInfo = GetBuildInfo()
	if buildInfo >= 100000 then
		_G.MerchantNameText = _G.MerchantFrame.TitleContainer.TitleText;
	end
	
	hooksecurefunc("MerchantFrame_UpdateMerchantInfo", function()
		VendorAddon:UpdateMerchantPositions()
	end)

	hooksecurefunc("MerchantFrame_UpdateBuybackInfo", function()
		VendorAddon:UpdateBuybackPositions()
	end)
end
