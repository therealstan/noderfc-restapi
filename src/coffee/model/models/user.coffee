bcrypt                  = require "bcryptjs"
_                       = require "underscore"
TimeSheetFetcher        = require "../model_fetchers/timesheet_fetcher"
ActivityTypeFetcher     = require "../model_fetchers/activity_type_fetcher"
ProfileSettingFetcher   = require "../model_fetchers/profile_setting_fetcher"
Model                   = require "./model"

salt = bcrypt.genSaltSync 10

class User extends Model
  constructor: ->
    super({
      id:
        abapName: "EMPLOYEE"
        type: "Numc_8"
      first_name:
        abapName: "FIRSTNAME"
        type: "Char_25"
      last_name:
        abapName: "LAST_NAME"
        type: "Char_25"
      atext:
        abapName: "ATEXT"
        type: "Char_5"
      controlling_area:
        abapName: "CO_AREA"
        type: "Char_4"
      cost_center:
        abapName: "COSTCENTER"
        type: "Char_10"
      org_unit:
        abapName: "ORG_UNIT"
        type: "Numc_8"
      is_manager:
        abapName: "IS_MANAGER"
        type: "Bool"
      company_code:
        abapName: "COMP_CODE"
        type: "Char_4"
      factory_calendar:
        abapName: "FACTORY_CALENDAR"
        type: "Char_2"
    })

  repr: () -> _.omit(this, 'attributes', '_attributes', 'conn')

  toPublic: () ->
    pub = _.clone(this)
    delete pub.conn
    return pub

  getTimeSheets: (options, cb, filters) ->
    fetcher = new TimeSheetFetcher()
    options.user_id = @id
    fetcher.fetch(@conn, options, cb, filters)

  getProfileSettings: (options, cb, filters) ->
    options.user_id = @username
    fetcher = new ProfileSettingFetcher()
    fetcher.fetch(@conn, options, cb, filters)

  getProfileSettingsById: (req, options, cb, filters) ->
    options.id = req.param "id"
    @getProfileSettings(options, cb, filters)

  getActivityTypes: (options, cb, filters) ->
    options.controlling_area = @controlling_area
    options.cost_center = @cost_center
    fetcher = new ActivityTypeFetcher()
    fetcher.fetch(@conn, options, cb, filters)

module.exports = User