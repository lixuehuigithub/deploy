-- ----------------------------
-- Procedure structure for pr_fill_tenant_app
-- ----------------------------
DROP PROCEDURE IF EXISTS `pr_fill_tenant_app`;
DELIMITER ;;
CREATE DEFINER=`cms`@`%` PROCEDURE `pr_fill_tenant_app`()
begin
  DECLARE i_TenantId BIGINT;
  DECLARE done INT DEFAULT 0;
  DECLARE cur_agent cursor for select tenant.id from `user-center`.`tenant` where id not in (select tenant_id from `o-service`.tenant_app where app_id='visitor') ;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done =TRUE ;

  OPEN cur_agent;
    read_loop:
  LOOP
    FETCH cur_agent into i_TenantId;
    if done
      then leave read_loop;
    end if ;
      INSERT INTO `o-service`.tenant_app
      ( app_id, app_key, push_key, push_address, tenant_id, expired_date, expired_date_type, status, create_time, update_time, name, icon, index_url, version, events, grant_type, scope, source_type,src_app_id)
      VALUES ( 'visitor', '7ZIBGi#_f6481T4geY1I', '123456', 'http://127.0.0.1/visitor-manager/event/receive', i_TenantId, null, 0, 1, '2018-10-17 10:50:01', '2018-11-20 13:59:08', '访客应用', '', '/app/visitor', '	v1.0', 'ACCESS_RECORD_ADD', 'client_credentials', null, 0,"visitor");
  end loop;

end
;;
DELIMITER ;
